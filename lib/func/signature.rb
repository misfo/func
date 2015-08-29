class Func

  class Signature
    class InvalidBlockPositionError < ArgumentError; end
    class MultipleSplatsError < ArgumentError; end

    def initialize(names)
      @args = []
      @has_splat = @has_block = false
      names.each_with_index do |name, i|
        @args << Arg.parse(name.to_s).tap do |arg|
          arg.after_splat = @has_splat

          if arg.is_splat?
            raise MultipleSplatsError if @has_splat
            @has_splat = true
          elsif arg.is_block?
            raise InvalidBlockPositionError if i != names.size - 1
            @has_block = true
          end
        end
      end
    end

    attr_reader :args

    def has_splat?() @has_splat end
    def has_block?() @has_block end

    alias :variadic? :has_splat?

    def arg_count
      args.size - (has_block? ? 1 : 0)
    end

    def arity
      if variadic?
        - arg_count
      else
        arg_count
      end
    end

    class Arg < Struct.new(:sigil, :name, :after_splat)
      def self.parse(string)
        new(*string.match(/\A([*&]?)(.*)/).captures)
      end

      alias :after_splat? :after_splat

      def is_splat?() sigil == '*' end
      def is_block?() sigil == '&' end
    end

  end

end