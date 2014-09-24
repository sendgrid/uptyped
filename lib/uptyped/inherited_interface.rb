require "uptyped/version"
require "uptyped/interface_validator"

module Uptyped
  module InheritedInterface
    def self.included(scope)
      scope.include_context "inherits interface"
    end

    shared_context 'inherits interface' do
      unless described_class.superclass == Object
        describe "public methods:" do
          it "should contain only public instance methods that are inherited" do
            validator = Uptyped::InterfaceValidator.new(described_class)

            expect(validator.public_instance_method_errors).to be_empty, validator.public_instance_method_errors.first
          end

          it "should contain only public class methods that are inherited" do
            validator = Uptyped::InterfaceValidator.new(described_class)
            expect(validator.public_class_method_errors).to be_empty, validator.public_class_method_errors.first
          end
        end

        describe "arity:" do
          context "instance methods" do
            it "should have the same public instance method arity as its superclass" do
              validator = Uptyped::InterfaceValidator.new(described_class)

              expect(validator.instance_method_arity_errors).to be_empty, validator.instance_method_arity_errors.first
            end
          end

          context "class methods" do
            it "should have the same public instance method arity as its superclass" do
              validator = Uptyped::InterfaceValidator.new(described_class)

              expect(validator.class_method_arity_errors).to be_empty, validator.class_method_arity_errors.first
            end
          end
        end
      end
    end

    def self.configure
      RSpec.configure do |config|
        config.include InheritedInterface
      end
    end
  end
end
