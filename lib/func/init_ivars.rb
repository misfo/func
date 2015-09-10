class Func
  module InitIvars

    def initialize(*args, &block)
      each_param_with_arg_index do |name, index|
        instance_variable_set("@#{name}", args[index])
      end
      if block
        name = block_param_name
        raise ArgumentError, "#{self.class}#initialize does not accept a block" if name.nil?
        instance_variable_set("@#{name}", block)
      end
    end

    private

    def each_param_with_arg_index
      init = method :initialize
      after_rest = false
      init.parameters.each_with_index do |(type, name), i|
        arg_index = case type
        when :block
          nil
        when :rest
          after_rest = true
          i..(i - init.arity.abs)
        when :opt, :req
          if after_rest
            i - init.arity.abs
          else
            i
          end
        else
          raise NotImplementedError, type
        end

        yield name, arg_index if arg_index
      end
    end

    def block_param_name
      type, name = method(:initialize).parameters.last
      name if type == :block
    end

  end
end
