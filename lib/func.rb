require 'func/signature'
require 'func/version'

class Func

  class << self
    def new_subclass(*names_in_signature)
      signature = Signature.new names_in_signature

      Class.new(self) do
        class << self
          def call(*args, &block)
            new(*args, &block).call
          end

          alias :[] :call
        end

        signature.arg_names.each_with_index do |arg_name, i|
          if !signature.variadic? || i < signature.splat_index
            define_method(arg_name) { @_args[i] }
          elsif i > signature.splat_index
            negative_index = i - signature.arg_count
            define_method(arg_name) { @_args[negative_index] }
          else
            range = i..(i - signature.arg_count)
            define_method(arg_name) { @_args[range] }
          end
        end

        if signature.block?
          define_method(signature.block_name) { @_block }
        end
      end
    end

    alias :[] :new_subclass
  end

  def initialize(*args, &block)
    @_args = args; @_block = block
  end

  def call
    raise NotImplementedError, 'Your Func must implement a no-arg `call` method'
  end

end
