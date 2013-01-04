require "op/version"
require "op/parser"

module Op
  def execute klass, arguments
    klass.new.execute(Parser.new(klass, arguments).parse)
  end
end
