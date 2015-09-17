class Func
  module InitIvars

    def initialize(*args, &block)
      params = Params.new method(:initialize)
      if block && !params.block?
        raise ArgumentError, "#{self.class}#initialize does not accept a block"
      end
      kwargs = args.pop if params.keys?

      params.each_with_arg_index do |name, index|
        value = case index
        when Numeric, Range then args[index]
        when Symbol         then kwargs.fetch(index)
        else                     block
        end

        instance_variable_set("@#{name}", value)
      end
    end

    class Params
      def initialize(method)
        @params = method.parameters
      end

      def each_with_arg_index
        negative_index = nil
        @params.each_with_index do |(type, name), i|
          arg_index = case type
          when :block
            nil
          when :rest
            negative_index = -1 - reqs_after_rest
            i..negative_index
          when :opt, :req
            if negative_index
              negative_index += 1
            else
              i
            end
          else # kwarg
            name
          end

          yield name, arg_index
        end
      end

      def keys?
        @params.any? { |(type, _)| [:key, :keyreq].include? type }
      end

      def block?
        type, _ = @params.last
        type == :block
      end

      private

      def reqs_after_rest
        count = nil
        @params.each do |(type, _), i|
          if count.nil?
            count = 0 if type == :rest
          elsif type == :req
            count += 1
          else
            break
          end
        end

        count
      end
    end

  end
end
