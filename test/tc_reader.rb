require 'test/unit'
require 'rprb'

include RpRb

class ReaderTest < Test::Unit::TestCase
   def setup
      @reader = Reader.new
   end

   def r(arg)
      @reader.read arg
   end

   def test_read
      assert_equal ['1'], @reader.read("1")
      assert_equal [['1']], @reader.read("{ 1 }")
      assert_equal [['1']], @reader.read("{1}")

      assert_equal ['1', ['1']], @reader.read('1 {1}')

      assert_equal [[]], @reader.read('{ }')

      assert_equal ['"1 2 3"'], r('"1 2 3"')
      assert_equal ['"proc {}"'], r('"proc {}"')
   end
end
