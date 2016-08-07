require 'hjson/ast/parser'
require 'hjson/ast/number_parser'

module Hjson
  module AST
    class Node < Parser
      def self.[](type)
        @names       ||= {}
        @names[type] ||= begin
          namespace  = name.split(/::/).slice(0..-2).join('::')
          const_name = parser_name(type, namespace)
          Object.const_get(const_name) if Object.const_defined?(const_name)
        end
      end

      def self.parser_name(type, namespace)
				type = type.to_s.split(?_).map(&:capitalize).join
        "#{namespace}::#{type}"
      end

      def with_whitespaces
        node(:whitespace)
        yield
        node(:whitespace)
      end

      def node(type, *args, &block)
        args.unshift(buffer)
        Node[type].new(*args).parse
      end
    end
  end
end

require 'hjson/ast/nodes/root'
require 'hjson/ast/nodes/object'
require 'hjson/ast/nodes/array'
require 'hjson/ast/nodes/any'
require 'hjson/ast/nodes/string'
require 'hjson/ast/nodes/multiline'
require 'hjson/ast/nodes/value'
require 'hjson/ast/nodes/whitespace'
require 'hjson/ast/nodes/keyname'
