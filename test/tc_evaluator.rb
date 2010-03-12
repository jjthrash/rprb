require 'test/unit'
require 'rprb'

include RpRb

class DCTest < Test::Unit::TestCase
   def setup
      @dc = DC.new
   end

   def e(arg)
      @dc.eval arg
   end

   def r(arg)
      @dc.read arg
   end

   def re(arg)
      e r(arg)
   end

   def s
      @dc.stack
   end

   def test_basic_eval
      re('nil nil')
      assert_equal [nil, nil], s

      re('clr 1 2 3')
      assert_equal [3, 2, 1], s
   end

   def test_basic_method_calling
      re('1 2 +')
      assert_equal [3], s

      re 'clr 1 2 3 4 4 array 5 push'
      assert_equal [[1, 2, 3, 4, 5]], s
   end

   def test_basic_Math_method_calling
      re('0 sin 0 cos')
      assert_equal [1.0, 0.0], s
   end

   def test_proc_calling
      re '"proc{|arg|1+arg}" eval 1 call'
      assert_equal [2], s

      re 'clr Math.method(:sin) 0 call'
      assert_equal [0.0], s
   end

   def test_basic_dc_methods
      re('0 dup')
      assert_equal [0, 0], s

      re('nil dup')
      assert_equal [nil, nil, 0, 0], s

      re('drop2 drop')
      assert_equal [0], s

      re('1 2')
      assert_equal [2, 1, 0], s

      re('drop dup2')
      assert_equal [1, 0, 1, 0], s

      re('drop2')
      assert_equal [1, 0], s

      re 'swap'
      assert_equal [0, 1], s

      re '1 pick'
      assert_equal [1, 0, 1], s

      re 'neg'
      assert_equal [-1, 0, 1], s

      re 'inc'
      assert_equal [0, 0, 1], s

      re 'dec'
      assert_equal [-1, 0, 1], s

      re 'len'
      assert_equal [3, -1, 0, 1], s

      re '[]'
      assert_equal [[], 3, -1, 0, 1], s
   end

   def test_variables
      re('0 1 :a sto')
      assert_equal [0], s

      re(':a rcl')
      assert_equal [1, 0], s
   end

   def test_if
      re('1 2 true if')
      assert_equal [1], s

      re('clr 1 2 false if')
      assert_equal [2], s
   end

   def test_not
      re 'false not'
      assert_equal [true], s

      re 'clr true not'
      assert_equal [false], s

      re 'clr nil not'
      assert_equal [true], s

      re 'clr 0 not'
      assert_equal [false], s
   end

   def test_while
      re '{ 1 } { len 5 == not } while'
      assert_equal [1, 1, 1, 1, 1], s
   end

   def test_array
      re '1 2 3 4 4 array'
      assert_equal [[1, 2, 3, 4]], s
   end

   def test_evaln
      re '{ 1 } 5 evaln'
      assert_equal [1, 1, 1, 1, 1], s
      
      re '3 dropn { dup2 + } 3 evaln'
      assert_equal [5, 3, 2, 1, 1], s
   end

   def test_stored_procedures
      re('{ dup2 + } :fib sto 1 1')
      assert_equal [1, 1], s
      re('fib fib')
      assert_equal [3, 2, 1, 1], s
      re(':fib rcl eval')
      assert_equal [5, 3, 2, 1, 1], s
      re(':fib rcl 2 evaln')
      assert_equal [13, 8, 5, 3, 2, 1, 1], s
   end

   def test_save_restore
      re '1 save 2 save restore save :control rcl'
      assert_equal [[2, 1]], s

      re('clr Array.new :control sto 1 save :control rcl')
      assert_equal [[1]], s

      re 'clr restore'
      assert_equal [1], s

      re 'clr :control rcl'
      assert_equal [[]], s
   end

   def test_each
      re '1 2 3 4 5 5 array { 2 * } each'
      assert_equal [10, 8, 6, 4, 2], s
   end

   def test_map
      re('1 2 3 4 5 5 array { 2 * } map')
      assert_equal [[2, 4, 6, 8, 10]], s

      re 'clr 1 2 3 4 5 5 array { neg } map'
      assert_equal [[-1, -2, -3, -4, -5]], s
   end

   def test_load
      require 'tempfile'
      thefile = nil
      Tempfile.open("tc_evaluator") { |file|
         thefile = file
         file.write <<-END
{ dup2 + } :fib sto
{ 1 1 } :blah sto
         END
      }

      re %Q{"#{thefile.path}" load}
      re 'blah :fib 3 exen'
      assert_equal [5, 3, 2, 1, 1], s
      thefile.delete
   end
end
