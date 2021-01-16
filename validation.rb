module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(name, type, *args)
      @validations ||= []
      @validations << { name: name, type: type, args: args }
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    def validate!
      self.class.instance_variable_get(:@validations).each do |arg|
        instance_var = instance_variable_by_name(arg[:name])
        send("validate_#{arg[:type]}", instance_var, *arg[:args])
      end
    end

    def validate_presence(value)
      raise 'Значение атрибута не может быть пустым' if value.nil? || value.empty?
    end

    def validate_format(value, format)
      raise 'Значение атрибута не соответствует формату' if value !~ format
    end

    def validate_type(value, type)
      raise 'Значение атрибута не соответствует заданному классу' unless value.is_a?(type)
    end

    def instance_variable_by_name(name)
      instance_var = "@#{name}"
      instance_variable_get(instance_var)
    end
  end
end
