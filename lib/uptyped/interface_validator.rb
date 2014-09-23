class Uptyped::InterfaceValidator
  attr_reader :public_instance_method_errors, :public_class_method_errors, :instance_method_arity_errors, :class_method_arity_errors

  def initialize(klass)
    @validated_class = klass
    @public_instance_method_errors = []
    @public_class_method_errors = []
    @instance_method_arity_errors = []
    @class_method_arity_errors = []
    check_for_extra_subclass_instance_methods
    check_for_extra_subclass_class_methods
    check_instance_methods_for_arity_mismatches
    check_class_methods_for_arity_mismatches
  end

  def success?
    (public_instance_method_errors + public_class_method_errors + instance_method_arity_errors + class_method_arity_errors).empty?
  end

  private

  def validated_class
    @validated_class
  end

  def check_for_extra_subclass_instance_methods
    extra_instance_methods = validated_class.instance_methods - validated_class.superclass.instance_methods
    unless extra_instance_methods.empty?
      error_message = "expected #{validated_class} to have the same public instance methods as #{validated_class.superclass}, got #{extra_instance_methods}."
      @public_instance_method_errors << error_message
    end
  end

  def check_for_extra_subclass_class_methods
    local_public_methods = validated_class.methods
    superclass_public_methods = validated_class.superclass.methods
    extra_public_methods = local_public_methods - superclass_public_methods
    unless extra_public_methods.empty?
      error_message = "expected #{validated_class} to have the same public class methods as #{validated_class.superclass}, got #{extra_public_methods}."
      @public_class_method_errors << error_message
    end
  end

  def check_instance_methods_for_arity_mismatches
    (validated_class.superclass.instance_methods - validated_class.superclass.superclass.instance_methods).push(:initialize).each do |method|
      klass_arity = validated_class.instance_method(method).arity
      superklass_arity = validated_class.superclass.instance_method(method).arity

      unless klass_arity == superklass_arity
        error_message = "#{validated_class}##{method.to_s} takes #{klass_arity} argument(s) while #{validated_class.superclass}##{method.to_s} takes #{superklass_arity} argument(s)."
        instance_method_arity_errors << error_message
      end
    end
  end

  def check_class_methods_for_arity_mismatches
    (validated_class.superclass.methods - validated_class.superclass.superclass.methods).each do |method|
      klass_arity = validated_class.method(method).arity
      superklass_arity = validated_class.superclass.method(method).arity

      unless klass_arity == superklass_arity
        error_message = "#{validated_class}.#{method.to_s} takes #{klass_arity} argument(s) while #{validated_class.superclass}.#{method.to_s} takes #{superklass_arity} argument(s)."
        @class_method_arity_errors << error_message
      end
    end
  end
end