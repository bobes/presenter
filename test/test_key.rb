require "helper"

class TestKey < Test::Unit::TestCase

  test "cast to array" do
    key = Key.new :name, String
    assert_equal ["1", "2", "three"], key.typecast([1, "2", "three"])
    assert_equal ["1", "three"], key.typecast([1, nil, "three"])
    assert_equal nil, key.typecast([""])
    assert_equal nil, key.typecast([nil])
  end
end
