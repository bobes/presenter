gem 'activesupport', '>= 2.3'

require 'active_support'

class Presenter
end

Dir[File.join(File.dirname(__FILE__), "presenter", "*.rb")].each do |file|
  require file
end

