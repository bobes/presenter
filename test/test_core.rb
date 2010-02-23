require "helper"

class TestCode < Test::Unit::TestCase

  test "module can be included" do
    klass = Class.new do
      include Presenter::Core
      key :name
    end
    instance = klass.new
    instance.name = "Fred"
  end

  test "key defines accessors" do
    klass = Class.new do
      include Presenter::Core
      key :name
    end
    instance = klass.new
    instance.name = "Fred"
    assert_equal "Fred", instance.name
    assert_equal true, instance.name?
  end

  test "keys are inheritable" do
    a = Class.new do
      include Presenter::Core
      key :name
    end
    b = Class.new(a) do
      key :age
    end
    c = Class.new(a) do
      key :role
    end
    assert a.keys[:name], b.keys[:name]
    assert c.keys[:age].nil?
  end

  test "setter casts" do
    klass = Class.new do
      include Presenter::Core
      Object.const_set :CustomType, Class.new
      def CustomType.typecast(value)
        value.to_s.reverse
      end
      key :name, CustomType
    end
    instance = klass.new
    instance.name = "Fred"
    assert_equal "derF", instance.name
  end

  test "accepts params in initializer" do
    klass = Class.new do
      include Presenter::Core
      key :name, String
      key :age, Integer
    end
    instance = klass.new(:name => "Fred", "age" => "35")
    assert_equal "Fred", instance.name
    assert_equal 35, instance.age
  end

  test "getters return default values" do
    klass = Class.new do
      include Presenter::Core
      key :name, :default => "Unknown"
    end
    assert_equal "Unknown", klass.new.name
  end

  test "nil in params takes precendence before default value" do
    klass = Class.new do
      include Presenter::Core
      key :name, :default => "Unknown"
    end
    instance = klass.new :name => nil
    assert_nil instance.name
  end

  test "getters cast default values" do
    klass = Class.new do
      include Presenter::Core
      key :age, String, :default => 35
    end
    assert_equal "35", klass.new.age
  end

  test "default values support procs" do
    age = Time.now.to_i
    klass = Class.new do
      include Presenter::Core
      key :age, String, :default => lambda { age }
    end
    assert_equal age.to_s, klass.new.age
  end

  test "presents defines collection reader" do
    klass = Class.new do
      include Presenter::Core
      presents :users
      def find_users; ["user1", "user2"] end
    end
    assert_equal ["user1", "user2"], klass.new.users
  end

  test "collection readers cache finders results" do
    klass = Class.new do
      include Presenter::Core
      presents :hits
      def find_hits; @count ||= 0; @count += 1 end
    end
    assert_equal 1, klass.new.hits
    assert_equal 1, klass.new.hits
  end

  test "collection readers can mixin module in items" do
    mod = Module.new do
      def name; "John Doe" end
    end
    klass = Class.new do
      include Presenter::Core
      presents :users, mod
      def find_users; ["user1", "user2"] end
    end
    users = klass.new.users
    assert_equal ["user1", "user2"], users
    assert_equal "John Doe", users.first.name
  end

  test "params returns cleaned up value hash" do
    klass = Class.new do
      include Presenter::Core
      key :name
      key :age
      key :role, :default => :guest
    end
    instance = klass.new :name => "John Doe"
    assert_equal({ :name => "John Doe" }, instance.params)
  end
end
