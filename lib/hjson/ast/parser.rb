require 'strscan'
require 'forwardable'
require 'hjson/errors'

module Hjson
  module AST
    class Parser
      attr_reader :payload, :source, :buffer, :options

      extend Forwardable
      def_delegators :buffer, :eos?, :getch, :pos, :string, :reset, :charpos
      alias_method :read, :getch

      def self.parsers
        @parsers ||= []
      end

      def self.parser(&parser)
        parsers << parser
      end

      def self.declared_vars
        @declared_vars ||= {}
      end

      def self.declare(var, val = nil, &block)
        declared_vars[var] = block_given? ? block : val
      end

      def self.rule(name, &block)
        define_method(:"#{name}?") do |c = nil|
          c = char unless c
          instance_exec(c, &block)
        end
      end

      def parse
        catch(:halt) { parsers.reduce(nil) { |_, parser| instance_eval(&parser) } }
      end

      def initialize(buffer, **options)
        @buffer  = buffer
        @payload = nil
        @options = options
        assign_declared_vars!
      end

      private

      def assign_declared_vars!
        self.class.declared_vars.each do |var, val|
          val =
            case val
            when Proc   then instance_eval(&val)
            when Symbol then send(val)
            when Fixnum then val
            else val.dup
            end
          instance_variable_set(:"@#{var}", val)
        end
      end

      def validate(expected)
        current = current_char
        fail SyntaxError,
          "Expected %p instead of %p" % [expected, current] if expected && expected != current
      end

      def halt(data = nil)
        throw :halt, data
      end

      def parsers
        self.class.parsers
      end

      def read_while(**options, &block)
        if options[:if] && respond_to?(options[:if], true)
          while char && send(options[:if])
            instance_eval(&block)
            read
          end
        else
          read while char && instance_exec(char, &block)
        end
      end

      def peek(offset = 0)
        string[charpos + offset]
      end

      def current_char
        string[charpos]
      end
      alias_method :char, :current_char

      def char?
        !!char
      end
    end
  end
end
