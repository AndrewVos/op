module Op
  class Parser
    def initialize klass
      @klass = klass
    end

    def parse arguments
      command = find_command(arguments.shift)

      result = {}
      until arguments.empty?
        part = arguments.shift
        if part.start_with?("--")
          long = part.gsub(/^\-\-/, "")
          argument = command.arguments.find {|a| a[:long] == long}
          if argument[:parameter]
            parameter = arguments.shift
            raise "Argument --#{argument[:long]} takes a parameter" if parameter.nil?
            result[argument[:name]] = parameter
          else
            result[argument[:name]] = true
          end
        elsif part.start_with?("-")
          part_parts = part.gsub(/^\-/, "").split("")
          part_parts.each_with_index do |part_part, index|
            argument = command.arguments.find{|a| a[:short] == part_part}
            if argument[:parameter]
              raise "Argument -#{argument[:short]} takes a parameter, so should come last" if index != part_parts.size - 1
              parameter = arguments.shift
              raise "Argument -#{argument[:short]} takes a parameter" if parameter.nil?
              result[argument[:name]] = parameter
            else
              result[argument[:name]] = true
            end
          end
        end
      end
      result
    end

    private
      def commands
        @klass.constants.select {|c| @klass.const_get(c).is_a? Class}.map{|c| @klass.const_get(c)}
      end

      def find_command name
        commands.find {|c| c.name.split("::").last.downcase == "#{name.downcase}command"}
      end
  end
end
