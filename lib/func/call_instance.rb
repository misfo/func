class Func
  module CallInstance
    def call(*args, &block)
      new(*args, &block).call
    end

    alias :[] :call

    def arity()      instance_method(:initialize).arity      end
    def parameters() instance_method(:initialize).parameters end
  end
end
