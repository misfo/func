require 'func/version'

class Func

  class << self
    def sig(&signature)
      Class.new(self) do
        @_signature = signature

        each_param_reader do |name, body|
          define_method(name, &body)
        end
      end
    end

    def call(*args, &block)
      new(*args, &block).call
    end

    alias :[] :call

    def arity
      @_signature.arity
    end

    private

    def each_param_reader
      after_rest = false
      @_signature.parameters.each_with_index do |(type, name), i|
        body = case type
        when :block
          proc { @_block }
        when :rest
          after_rest = true
          range = i..(i - @_signature.arity.abs)
          proc { @_args[range] }
        when :opt
          index = if after_rest
                    i - @_signature.arity.abs
                  else
                    i
                  end
          proc { @_args[index] }
        else
          raise NotImplementedError, type
        end

        yield name, body
      end
    end
  end

  def initialize(*args, &block)
    @_args = args; @_block = block
  end

  def call
    raise NotImplementedError, 'Func must be subclassed with a no-arg `call` method'
  end

end
