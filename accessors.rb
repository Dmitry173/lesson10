module Accessors

  def attr_accessor_with_history(*args)
    args.each do |arg|
      instance_var = "@#{arg}".to_sym
      history_var = "@#{arg}_history".to_sym
      define_method(arg) { instance_variable_get(instance_var) }
      define_method("#{arg}_history") { instance_variable_get(history_var) }
      define_method("@#{arg}=".to_sym) do |value|
        if instance_variable_get(history_var).nil?
          instance_variable_set(history_var, [])
        else
          instance_variable_get(history_var).push(instance_variable_get(instance_var))
        end
        instance_variable_set(instance_var, value)
      end
    end
  end

  def strong_attr_accessor(name, type)
    instance_var_name = "@#{name}".to_sym
    define_method(name) { instance_variable_get(instance_var_name) }
    define_method("#{name}=".to_sym) do |value|
      raise 'Incorrect type' unless value.is_a?(type)

      instance_variable_set(instance_var_name, value)
    end
  end
end
