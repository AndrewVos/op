require "minitest/unit"
require "minitest/autorun"
require "minitest/pride"

$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "../lib")))
require "argumentsicles/parser"

module Argumentsicles
  class TestParser < MiniTest::Unit::TestCase
    class Example
      class SimpleCommand
        class << self
          attr_reader :arguments

          def add_argument argument
            @arguments ||= []
            @arguments << argument
          end

          def clear_arguments
            @arguments = []
          end
        end
      end
    end

    def setup
      Example::SimpleCommand.clear_arguments
    end

    def test_parses_short_arguments
      Example::SimpleCommand.add_argument({:name => :simple, :short => "s"})
      result = Parser.new(Example).parse(["simple", "-s"])
      assert_equal true, result[:simple]
    end

    def test_parses_grouped_short_arguments
      Example::SimpleCommand.add_argument({:name => :meh1, :short => "a"})
      Example::SimpleCommand.add_argument({:name => :meh2, :short => "b"})
      result = Parser.new(Example).parse(["simple", "-ab"])
      assert_equal true, result[:meh1]
      assert_equal true, result[:meh2]
    end

    def test_parses_short_arguments_with_parameter
      Example::SimpleCommand.add_argument({:name => :param1, :short => "p", :parameter => true})
      result = Parser.new(Example).parse(["simple", "-p", "param value"])
      assert_equal "param value", result[:param1]
    end

    def test_crashes_if_parametered_short_argument_has_no_parameter
      Example::SimpleCommand.add_argument({:name => :param1, :short => "p", :parameter => true})
      error = nil
      begin
        result = Parser.new(Example).parse(["simple", "-p"])
      rescue Exception => exception
        error = exception
      end
      assert_equal "Argument -p takes a parameter", exception.message
    end

    def test_crashes_if_parametered_short_argument_is_not_last_in_a_grouped_list
      error = nil
      Example::SimpleCommand.add_argument({:name => :param1, :short => "p", :parameter => true})
      Example::SimpleCommand.add_argument({:name => :param2, :short => "r"})
      begin
        result = Parser.new(Example).parse(["simple", "-pr"])
      rescue Exception => exception
        error = exception
      end
      assert_equal "Argument -p takes a parameter, so should come last", exception.message
    end

    def test_parses_long_arguments
      Example::SimpleCommand.add_argument({:name => :simple, :long => "simple"})
      result = Parser.new(Example).parse(["simple", "--simple"])
      assert_equal true, result[:simple]
    end

    def test_parses_long_arguments_with_parameters
      Example::SimpleCommand.add_argument({:name => :param1, :long => "param1", :parameter => true})
      result = Parser.new(Example).parse(["simple", "--param1", "param value"])
      assert_equal "param value", result[:param1]
    end

    def test_crashes_if_parametered_long_argument_has_no_parameter
      Example::SimpleCommand.add_argument({:name => :param1, :long => "param1", :parameter => true})
      error = nil
      begin
        result = Parser.new(Example).parse(["simple", "--param1"])
      rescue Exception => exception
        error = exception
      end
      assert_equal "Argument --param1 takes a parameter", exception.message
    end
  end
end
