require "func/version"

class Func
  class << self
    def new_subclass(*arg_names)
      block_name = arg_names.last.to_s[/\A&(.+)/, 1]
      arg_names.pop unless block_name.nil?

      Class.new(self) do
        class << self
          def call(*args, &block)
            new(*args, &block).call
          end

          alias :[] :call
        end

        arg_names.each_with_index do |arg_name, i|
          define_method(arg_name) { @_args[i] }
        end

        unless block_name.nil?
          define_method(block_name) { @_block }
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
