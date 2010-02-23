class Presenter

  module Core

    def self.included(model)
      model.class_eval do
        extend ClassMethods
        include InstanceMethods
      end
    end
  end

  module ClassMethods

    def key(*args)
      key = Key.new(*args)
      keys[key.name.to_sym] = key
      create_accessors_for(key)
    end

    def presents(*names)
      mixin = names.pop if names.last.is_a?(Module)
      names.each { |name| create_finder_for(name, mixin) }
    end

    def keys
      @keys ||= superclass.respond_to?(:keys) ? superclass.keys.dup : {}
    end

    private

    def create_accessors_for(key)
      module_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{key.name}
          values.include?(:#{key.name}) ? values[:#{key.name}] : keys[:#{key.name}].default_value
        end

        def #{key.name}=(value)
          values[:#{key.name}] = keys[:#{key.name}].typecast(value)
        end

        def #{key.name}?
          #{key.name}.respond_to?(:empty?) ? !#{key.name}.empty? : !!#{key.name}
        end
      EOS
    end

    def create_finder_for(name, mixin = nil)
      @mixins ||= {}
      @mixins[name] = mixin
      module_eval <<-EOS, __FILE__, __LINE__ + 1
        def #{name}
          @collections ||= {}
          @collections[:#{name}] ||= wrap_#{name}(find_#{name})
        end

        private

        def wrap_#{name}(items)
          if mixin = self.class.instance_variable_get("@mixins")[:#{name}]
            items.each { |item| item.extend(mixin) }
          end
          items
        end

        def find_#{name}
          raise NotImplementedError.new("find_#{name} method not implemented")
        end
      EOS
    end
  end

  module InstanceMethods

    def initialize(params = nil)
      if params
        params.each do |name, value|
          self.send "#{name}=", value if keys[name.to_sym]
        end
      end
    end

    def keys
      self.class.keys
    end

    def values
      @values ||= {}
    end

    def params
      @values.delete_if { |key, value| value.nil? || (value.respond_to?(:empty?) && value.empty?) }
    end
  end

  include Core
end

