require "helper"

class TestTypes < Test::Unit::TestCase

  test "cast to boolean" do
    assert_equal true, Boolean.typecast(true)
    assert_equal true, Boolean.typecast("true")
    assert_equal true, Boolean.typecast(1)
    assert_equal true, Boolean.typecast("1")
    assert_equal false, Boolean.typecast(false)
    assert_equal false, Boolean.typecast("false")
    assert_equal false, Boolean.typecast(0)
    assert_equal false, Boolean.typecast("0")
    assert_nil Boolean.typecast(123)
    assert_nil Boolean.typecast("huh?")
  end

  test "cast to float" do
    assert_equal 35.5, Float.typecast("35.5")
    assert_nil Float.typecast("huh?")
  end

  test "cast to integer" do
    assert_equal 35, Integer.typecast(35)
    assert_equal 35, Integer.typecast("35")
    assert_equal 35, Integer.typecast("35.5")
    assert_nil Integer.typecast("huh?")
  end

  test "cast to string" do
    assert_equal "35", String.typecast(35)
    assert_equal "true", String.typecast(true)
    assert_equal "false", String.typecast(false)
    assert_equal "anything", String.typecast("anything")
    assert_nil String.typecast(nil)
  end

  test "cast to time" do
    assert_equal Time.local(2009, 12, 28, 10, 35, 25), Time.typecast({
      :year => "2009", :month => "12", :day => "28", :hour => "10", :minute => "35", :second => "25"
    })
    assert_equal Time.utc(2009, 12, 28, 9, 35, 25), Time.typecast("Mon Dec 28 11:35:25 +0200 2009")
    assert_equal Time.local(2009, 12, 28, 9, 35), Time.typecast("28/12/2009 09:35", :format => "%d/%m/%Y %H:%M")
    assert_equal Time.local(2009, 12, 28, 10, 35, 25), Time.typecast(Time.local(2009, 12, 28, 10, 35, 25))
    assert_equal Time.utc(2009, 12, 28, 10, 35, 25), Time.typecast(Time.utc(2009, 12, 28, 10, 35, 25))
    assert_equal Time.local(2009, 12, 28), Time.typecast(Date.new(2009, 12, 28))
  end
end
