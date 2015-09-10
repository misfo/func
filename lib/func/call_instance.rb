require 'func/callable'

class Func
  module CallInstance
    include Callable

    def call(*args, &block)
      new(*args, &block).call
    end

    private

    def signature_method
      instance_method(:initialize)
    end
  end
end
