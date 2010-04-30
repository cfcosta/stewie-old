# encoding: utf-8

# Named parameter assertion helper, from Refactoring: Ruby Edition
module AssertValidKeys
  def assert_valid_keys(*valid_keys)
    unknown_keys = keys - [valid_keys].flatten
    if unkown_keys.any?
      raise ArgumentError, "Unkown key(s): #{unknown_keys.join(", ")}"
    end
  end
end

class Hash
  include AssertValidKeys
  # Dynamic method definition module, from Refactoring: Ruby Edition
  def to_module
    hash = self
    Module.new do
      hash.each_pair do |key, value|
        define_method key.to_sym do
          value
        end
      end
    end
  end
end

# Depreciation helper, from Refactoring: Ruby Edition
class Module
  def deprecate(method_name, &block)
    module_eval <<-END
      alias_method :deprecated_#{method_name}, :#{method_name}
      def #{method_name}(*args, &block)
        $stderr.puts "Warning: calling deprecated method\
        #{self}.#{method_name}. This method will be removed in a future release."
        deprecated_#{method_name}(*args, &block)
      end
    END
  end
end
