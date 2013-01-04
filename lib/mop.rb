require "mop/version"
require "mop/parser"

module Mop
  def execute klass, arguments
    klass.new.execute(Parser.new(klass, arguments).parse)
  end
end
