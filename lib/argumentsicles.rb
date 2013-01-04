require "argumentsicles/version"
require "argumentsicles/parser"

module Argumentsicles
  def execute klass, arguments
    klass.new.execute(Parser.new(klass, arguments).parse)
  end
end
