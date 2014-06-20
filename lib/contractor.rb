require "contractor/version"

module Contractor
  module InheritedInterface
    def self.included(scope)
      scope.include_context "inherits interface"
    end

    shared_context 'inherits interface' do
      unless described_class.superclass == Object || InheritedInterface.configuration.white_list.include?(described_class)
        describe "public methods:" do
          it "should contain only public instance methods that are inherited" do
            local_instance_methods = described_class.instance_methods
            superclass_instance_methods = described_class.superclass.instance_methods
            extra_instance_methods = local_instance_methods - superclass_instance_methods
            error_message = "expected #{described_class} to have the same public instance methods as #{described_class.superclass}, got #{extra_instance_methods}"
            expect(extra_instance_methods).to eq([]), error_message
          end

          it "should contain only public methods that are inherited" do
            local_public_methods = described_class.methods
            superclass_punlic_methods = described_class.superclass.methods
            extra_public_methods = local_public_methods - superclass_punlic_methods
            error_message = "expected #{described_class} to have the same public class methods as #{described_class.superclass}, got #{extra_public_methods}"
            expect(extra_public_methods).to eq([]), error_message
          end
        end

        describe "arity:" do
          context "instance methods" do
            (described_class.superclass.instance_methods - described_class.superclass.superclass.instance_methods).push(:initialize).each do |method|
              it "should have the same public instance method arity as its superclass" do
                klass_arity = described_class.instance_method(method).arity
                superklass_arity = described_class.superclass.instance_method(method).arity
                arity_fail = "#{described_class}##{method.to_s} takes #{klass_arity} arguments while #{described_class.superclass}##{method.to_s} takes #{superklass_arity} arguments"
                expect(klass_arity).to eq(superklass_arity), arity_fail
              end
            end
          end

          context "class methods" do
            (described_class.superclass.methods - described_class.superclass.superclass.methods).each do |method|
              it "should have the same public instance method arity as its superclass" do
                klass_arity = described_class.method(method).arity
                superklass_arity = described_class.superclass.method(method).arity
                arity_fail = "#{described_class}.#{method.to_s} takes #{klass_arity} arguments while #{described_class.superclass}.#{method.to_s} takes #{superklass_arity} arguments"
                expect(klass_arity).to eq(superklass_arity), arity_fail
              end
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
