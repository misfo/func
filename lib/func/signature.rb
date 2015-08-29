class Func

  class Signature
    class InvalidBlockPositionError < ArgumentError; end
    class MultipleSplatsError < ArgumentError; end

    def initialize(names)
      @names = names
      interpret_and_validate!
    end

    attr_reader :names, :arg_names, :block_name, :splat_name, :splat_index

    def block?
      !block_name.nil?
    end

    def arg_count
      arg_names.size
    end

    def variadic?
      !splat_index.nil?
    end

    private

    def interpret_and_validate!
      @arg_names = []

      names.each_with_index do |name, i|
        string = name.to_s
        if splat_name = string[/\A\*(.+)/, 1]
          raise MultipleSplatsError unless @splat_index.nil?
          @splat_index = i
          @arg_names << splat_name
        elsif @block_name = string[/\A&(.+)/, 1]
          raise InvalidBlockPositionError unless i == names.size - 1
        else
          @arg_names << string
        end
      end
    end


  end

end