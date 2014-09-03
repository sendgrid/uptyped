require_relative 'spec_helper'

describe Uptyped::InterfaceValidator do
  before(:each) do
    class TestSuperClass
    end

    class TestSubClass < TestSuperClass
    end
  end

  context 'checking public methods' do
    context 'extra method on the subclass' do
      it 'fails and sets an error message' do
        class TestSubClass
          def extra_instance_method
          end
        end

        validated_class = TestSubClass
        superclass = TestSuperClass
        interface_validator = Uptyped::InterfaceValidator.new(TestSubClass)
        expect(interface_validator).to_not be_success
        expect(interface_validator.public_instance_method_errors).to eq(["expected #{validated_class} to have the same public instance methods as #{superclass}, got [:extra_instance_method]."])

        class TestSubClass
          undef extra_instance_method
        end
      end
    end

    context 'extra class method on subclass' do
      it 'fails and sets an error message' do
        class TestSubClass
          def self.extra_class_method
          end
        end
        validated_class = TestSubClass
        superclass = TestSuperClass
        interface_validator = Uptyped::InterfaceValidator.new(TestSubClass)
        expect(interface_validator).to_not be_success
        expect(interface_validator.public_class_method_errors).to eq(["expected #{validated_class} to have the same public class methods as #{superclass}, got [:extra_class_method]."])

        class << TestSubClass
          remove_method :extra_class_method
        end
      end
    end
  end

  context 'checking arity' do
    context 'mismatch on public instance methods' do
      it 'fails and sets an error message' do

        class TestSuperClass
          def foo
          end
        end

        class TestSubClass < TestSuperClass
          def foo(bar)
          end
        end

        interface_validator = Uptyped::InterfaceValidator.new(TestSubClass)
        expect(interface_validator).to_not be_success
        expect(interface_validator.instance_method_arity_errors).to eq(["TestSubClass#foo takes 1 argument(s) while TestSuperClass#foo takes 0 argument(s)."])

        class TestSubClass
          undef foo
        end

        class TestSuperClass
          undef foo
        end
      end
    end
  end

  context 'mismatch on public class methods' do
    it 'fails and sets an error message' do

      class TestSuperClass
        def self.foo
        end
      end

      class TestSubClass
        def self.foo(bar)
        end
      end

      interface_validator = Uptyped::InterfaceValidator.new(TestSubClass)
      expect(interface_validator).to_not be_success
      expect(interface_validator.class_method_arity_errors).to eq(["TestSubClass.foo takes 1 argument(s) while TestSuperClass.foo takes 0 argument(s)."])
    end
  end
end