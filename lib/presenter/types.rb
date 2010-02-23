class Boolean

  def self.typecast(value)
    if ["true", "1"].include?(value.to_s.downcase)
      true
    elsif ["false", "0"].include?(value.to_s.downcase)
      false
    else
      nil
    end
  end
end

class Float

  def self.typecast(value)
    value_to_f = value.to_f
    value_to_f == 0 && value.to_s !~ /^0*\.?0+/ ? nil : value_to_f
  end
end

class Integer

  def self.typecast(value)
    value_to_i = value.to_i
    value_to_i == 0 && value.to_s !~ /^(0x|0b)?0+/ ? nil : value_to_i
  end
end

class Object

  def self.typecast(value)
    value
  end
end

class String

  def self.typecast(value)
    value.nil? ? nil : value.to_s
  end
end

class Time

  def self.typecast(value, options = {})
    if value.is_a?(Time)
      value
    elsif value.is_a?(Hash)
      Time.local(*value.values_at(:year, :month, :day, :hour, :minute, :second))
    elsif value.is_a?(Date)
      Time.local(value.year, value.month, value.day)
    else
      begin
        dt = Date._strptime(value.to_s, options[:format] || "%a %b %d %H:%M:%S %Z %Y")
        time = Time.local(dt[:year], dt[:mon], dt[:mday], dt[:hour], dt[:min], dt[:sec])
        time += (time.utc_offset - dt[:offset]) if dt[:offset]
        time
      rescue StandardError => e
        nil
      end
    end
  end
end
