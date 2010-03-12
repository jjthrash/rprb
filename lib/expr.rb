# This code is release by the authors into the Public Domain

# stream: expr+
# expr: block | atom | comment
# string_literal: duh
# block: { stream }
# atom: \S+ | string_literal
# comment: # anything endl
# endl: \n
#

require 'rubygems'
require 'packrat/grammar'

module RpRb
   Grammar = Packrat::Grammar.new do
      start_symbol :Stream

      S = hidden(/\s*/)
      FS = hidden(/\s\s*/)

      prod :Stream, [mult(:Expression), ast(:Stream)]

      prod :StringLiteral, [/"(?:[^"]|\\")*"/, lift(0)]

      prod :Block, [hidden('{'), S, :Stream, S, hidden('}'), ast(:Block)]

      prod :Atom, [any(:StringLiteral, /[^{} \t]+/), lift(0)]

      rule :Expression, [S, any(:Block, :Atom), S, ast(:Expression)]
   end

   Parser = Grammar.interpreting_parser

   class Reader 
      def read(string)
         to_stream(Parser.parse_string(string))
      end

      include RpRb::Grammar::ASTs

      def to_stream(ast)
         case ast
         when Stream
            ast.children[0].collect { |child| to_stream(child) }
         when Expression, Block
            to_stream ast.children[0]
         else
            ast
         end
      end
   end
end

if __FILE__ == $0
   require 'pp'

   while gets
      puts "Parser output:"
      pp RpRb::Parser.parse_string($_.chomp)
      puts "Reader output:"
      pp RpRb::Reader.new.read($_.chomp)
   end
end
