require 'forwardable'

class Func
  module Callable
    extend Forwardable

    [:[], :===].each do |method_name|
      define_method(method_name) { |*args, &block| call(*args, &block) }
    end

    def lambda?
      true
    end

    def to_proc
      method(:call).to_proc
    end

    def_delegators :signature_method, :arity, :parameters

    private

    def signature_method
      method(:call)
    end
  end
end
