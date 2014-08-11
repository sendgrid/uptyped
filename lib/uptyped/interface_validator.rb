class Uptyped::InterfaceValidator
  attr_reader :errors

  def initialize(klass)
    @validated_class = klass
    @errors = []
    check_for_extra_subclass_instance_methods
    check_for_extra_subclass_class_methods
    check_instance_methods_for_arity_mismatches
    check_class_methods_for_arity_mismatches
  end

  def success?
    @errors.size == 0
  end

  private

  def validated_class
    @validated_class
  end

  def check_for_extra_subclass_instance_methods
    extra_instance_methods = validated_class.instance_methods - validated_class.superclass.instance_methods
    unless extra_instance_methods.empty?
      error_message = "expected #{validated_class} to have the same public instance methods as #{validated_class.superclass}, got #{extra_instance_methods}."
      @errors << error_message
    end
  end

  def check_for_extra_subclass_class_methods
    local_public_methods = validated_class.methods
    superclass_public_methods = validated_class.superclass.methods
    extra_public_methods = local_public_methods - superclass_public_methods
    unless extra_public_methods.empty?
      error_message = "expected #{ validated_class} to have the same public class methods as #{ validated_class.superclass}, got #{extra_public_methods}."
      @errors << error_message
    end
  end

  def check_instance_methods_for_arity_mismatches
    (validated_class.superclass.instance_methods - validated_class.superclass.superclass.instance_methods).push(:initialize).each do |method|
      klass_arity = validated_class.instance_method(method).arity
      superklass_arity = validated_class.superclass.instance_method(method).arity

      unless klass_arity == superklass_arity
        @errors << "#{validated_class}##{method.to_s} takes #{klass_arity} argument(s) while #{validated_class.superclass}##{method.to_s} takes #{superklass_arity} argument(s)."
      end
    end
  end

  def check_class_methods_for_arity_mismatches
    (validated_class.superclass.methods - validated_class.superclass.superclass.methods).each do |method|
      klass_arity = validated_class.method(method).arity
      superklass_arity = validated_class.superclass.method(method).arity

      unless klass_arity == superklass_arity
        @errors << "#{validated_class}.#{method.to_s} takes #{klass_arity} argument(s) while #{validated_class.superclass}.#{method.to_s} takes #{superklass_arity} argument(s)."
      end
    end
  end
end