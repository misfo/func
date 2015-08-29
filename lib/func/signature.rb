class Func

  class Signature < Struct.new(:names)
    def block_name
      return @block_name if defined?(@block_name)
      @block_name = names.last.to_s[/\A&(.+)/, 1]
    end

    def block?
      !block_name.nil?
    end

    def arg_names
      @arg_names ||= begin
        ns = if block?
          names[0...-1]
        else
          names.dup
        end
        ns[splat_index] = splat_name if variadic?

        ns
      end
    end

    def arg_count
      arg_names.size
    end

    def variadic?
      !splat_index.nil?
    end

    def splat_name()  splat_name_and_index && splat_name_and_index.first end
    def splat_index() splat_name_and_index && splat_name_and_index.last  end

    private

    def splat_name_and_index
      # @splat_name_and_index ||= begin
        names.each_with_index do |name, i|
          if splat_name = name.to_s[/\A\*(.+)/, 1]
            return splat_name, i
          end
        end

      nil
      # end
    end


  end

end