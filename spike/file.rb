class Application
  class DeployCommand
    def self.help; "Deploy your project" end
    def self.arguments
      []
    end

    def execute arguments
      puts "Deploying..."
      p arguments
    end
  end

  class GenerateCommand
    def self.help; "Generate project" end
    def self.arguments
      [
        {:name => :output, :short => "o", :long => "output", :parameter => true, :help => "Output file"},
        {:name => :random, :short => "r", :long => "random", :parameter => false, :help => "Use randomness"}
      ]
    end

    def execute arguments
      puts "Generating..."
      p arguments
    end
  end
end

class Argumentsicals
  attr_reader :klass

  def initialize klass
    @klass = klass
  end

  def commands
    klass.constants.select {|c| klass.const_get(c).is_a? Class}.map{|c| klass.const_get(c)}
  end

  def find_command name
    commands.find {|c| c.name.split("::").last.downcase == "#{name.downcase}command"}
  end

  def execute_arguments args
    command = find_command(args.shift)
    command.new.execute(parse_arguments(command, args))
  end

  def parse_arguments command, args
    arguments = {}

    until args.empty?
      part = args.shift
      if part.start_with?("--")
        command_name = part.gsub(/^\-\-/, "")
        argument = command.arguments.find {|a| a[:long] == command_name}
        raise "Could not find argument with name #{command_name}" unless argument
        if argument[:parameter]
          arguments[argument[:name]] = args.shift
        else
          arguments[argument[:name]] = true
        end
      elsif part.start_with?("-")
        part_parts = part.gsub(/^\-/, "").split("")
        part_parts.each_with_index do |part_part, index|
          argument = command.arguments.find{|a| a[:short] == part_part}
          if argument[:parameter] && index != part_parts.size - 1
            raise "Argument -#{argument[:short]} must be the last argument in a parameter section, because it takes a value"
          end
          if argument[:parameter]
            arguments[argument[:name]] = args.shift
          else
            arguments[argument[:name]] = true
          end
        end
      end
    end

    command.arguments.each {|a| arguments[a[:name]] = false unless arguments.keys.include?(a[:name])}
    arguments
  end
end

Argumentsicals.new(Application).execute_arguments(ARGV)
