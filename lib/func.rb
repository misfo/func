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

        signature.args.each_with_index do |arg, i|
          if arg.is_block?
            define_method(arg.name) { @_block }
          else
            index_or_range = if arg.is_splat?
              i..(i - signature.arg_count)
            elsif arg.after_splat?
              i - signature.arg_count
            else
              i
            end
            define_method(arg.name) { @_args[index_or_range] }
          end
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
