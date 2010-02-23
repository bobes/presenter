class Key

  attr_accessor :name

  def initialize(*args)
    @options = args.last.is_a?(Hash) ? args.pop : {}
    @name, @type = args.shift.to_s, args.shift || Object
    @default_value = @options.delete(:default)
    @options = nil if @type.method(:typecast).arity == 1
  end

  def typecast(value)
    if value.is_a?(Array)
      array = value.map { |v| typecast(v) }.compact
      array.any? ? array : nil
    elsif value.nil? || (value.respond_to?(:empty?) && value.empty?)
      nil
    else
      @options ? @type.typecast(value, @options) : @type.typecast(value)
    end
  end

  def default_value
    value = @default_value.is_a?(Proc) ? @default_value.call : @default_value
    @type.typecast(value)
  end

  def to_s
    "#<Key: name=#{name}, type=#{type}>"
  end
end
