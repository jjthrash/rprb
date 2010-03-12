# This code is release by the authors into the Public Domain

module Enumerable
    def collect_with_index
        result = []
        each_with_index { |elem, i|
            result << yield(elem, i)
        }
        result
    end
end

#class Rational
#    def inspect
#        to_s
#    end
#end

def trythese(*procs)
    if procs.length == 0
        raise "Ahhg!"
    else
        begin
            procs[0].call
        rescue Exception => error
            #puts "ERROR: " + error
            trythese(*procs[1..-1])
        end
    end
end

require 'expr'

module RpRb
class DC
    def initialize
        @reader = Reader.new

        @stack = []

        @registers = {
            :eval => proc { |x| eval x },
            :read => proc { |x| read x },

            :p => proc { ||
                puts "___"
                puts @stack.collect_with_index { |entry, i| "%3d: %s" % [i, entry.inspect] }.reverse.join("\n")
                puts "---"
                :noval
            },

            :pick => proc { |n| @stack[n] },
            :del => proc { |n| @stack.slice!(n); :noval },
            :sto => proc { |val, sym| @registers[sym] = val; :noval },
            :rcl => proc { |sym| @registers[sym] },
            :if => proc { |den, elz, test| if test; den; else; elz; end },
            :len => proc { || @stack.length },

			:push => proc { |array, elem| array.push elem; array },

            :while => proc { |expr, cond| loop { eval(cond); break unless @stack.shift; eval(expr) }; :noval },
            :evaln => proc { |expr, n| n.times { eval(expr) }; :noval },
            :loop => proc { |expr, times| times.times { |i| @stack.unshift(i); eval(expr) }; :noval },
            :each => proc { |enumerable, expr| enumerable.each { |elem| @stack.unshift(elem); eval(expr) }; :noval },

            :array => proc { |length| @stack.slice!(0, length).reverse },

			:regs => proc { || @registers.keys },
        }


        [
            read('{ Array.new } :"[]" sto'),
            read('0 array :control sto'),
            read('{ false true 2 pick if 1 del } :not sto'),
            read('{ :control rcl swap unshift :control sto } :save sto'),
            read('{ :control rcl 0 slice! } :restore sto'),
            read('{ 1 pick 2 del } :swap sto'),
            read('{ 0 del } :drop sto'),
            read('{ 0 pick } :dup sto'),
            read('{ {drop} swap evaln } :dropn sto'),
            read('{ 2 dropn } :drop2 sto'),
            read('{ 2 dupn } :dup2 sto'),
            read('{ len dropn } :clr sto'),
            read('{ rcl eval } :exe sto'),
            read('{ swap rcl swap evaln } :exen sto'),
            read('{ 1 - } :dec sto'),
            read('{ 1 + } :inc sto'),
            read('{ -1 * } :neg sto'),
            read('{ 1.0 swap / } :inv sto'),
            read('{ restore dup save } :peek sto'),
            read('{ restore drop save } :poke sto'),
            read('{ save {peek 1 - pick} peek evaln restore drop } :dupn sto'),
            read('0 array :nop sto'),
            read('{ swap dup length save swap each restore array } :map sto'),
            read('{ File swap open save peek readlines restore close drop } :slurp sto'),
            read('{ slurp {chomp} map {read} map {eval} each } :load sto'),
            read('{ inc dup pick swap del } :take sto'),
            read('{ len {+} swap dec evaln } :sum sto'),
        ].each { |stream| eval(stream) }
    end

    def stack
        @stack.dup
    end

    def read(val)
        @reader.read val
    end

    def eval(tokens)
        #puts "Eval-ing #{tokens.inspect}"
        tokens.each { |token|
            #puts "processing token #{token.inspect}..."
            result = trythese(
             *[
                proc { execute(token.intern)                     },
                proc { parse_code(token)                         },
                proc { Kernel.eval(token)                        },
                proc { puts("Error, nothing left to do"); :noval },
              ]
            )

            unless result == :noval
                @stack.unshift result
            end
        }

        :noval
    end

    def parse_code(stream)
        if stream.is_a? Array
            stream
        else
            raise "#{stream.inspect} isn't code!"
        end
    end

    def execute(fn)
        # check if /fn/ names a register
        if @registers.include? fn
            case @registers[fn]
            when Proc, Method
                values = @stack.slice!(0, @registers[fn].arity).reverse
                return @registers[fn].call(*values)
            else
                return eval(@registers[fn])
            end
        end

        # check if /fn/ is a valid function call for an item on the stack
        @stack.each_with_index { |src, arity|
            begin
                if fn == :call and (src.is_a?(Proc) or src.is_a?(Method)) and (src.arity == arity or src.arity == -1)
                    values = @stack.slice!(0, arity + 1).reverse
                    return values[0].call(*values[1..-1])
                elsif src.respond_to?(fn) and (src.method(fn).arity == arity or src.method(fn).arity == -1)
                    values = @stack.slice!(0, arity + 1).reverse
                    return values[0].send(fn, *values[1..-1])
                end
            rescue ArgumentsError
            end
        }

        # check if /fn/ is a valid method of Kernel or Math
        [Kernel, Math].each { |src|
            begin
                if src.respond_to? fn
                    values = @stack.slice!(0, src.method(fn).arity).reverse
                    return src.send(fn, *values)
                end
            rescue
            end
        }

        raise "Couldn't execute function on stack item, DC, Kernel, or Math"
    end
end
end

if __FILE__ == $0
    dc = RpRb::DC.new
    while gets
        dc.eval dc.read($_.chomp)
    end
end

# vim:ts=4:sw=4
