require 'rubygems'
require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'presenter'

class Test::Unit::TestCase

  def self.test(name, &block)
    test_name = "test_#{name.gsub(/\s+/,'_')}".downcase
    define_method(test_name, &block)
  end
end
