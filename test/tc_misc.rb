require 'test/unit'
require 'rprb'

class MiscTest < Test::Unit::TestCase
   def test_collect_with_index
      assert_equal [0, 1, 2, 3], [1, 2, 3, 4].collect_with_index { |a, i| i }
   end
end
