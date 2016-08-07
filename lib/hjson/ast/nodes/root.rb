module Hjson
  module AST
    class Root < Node
      # Reads useless whitespaces such as \s, \t and any comments
      parser { node(:whitespace) }
      parser do
        hjson =
          case char
          when ?{ then node(:object, class_constant: options[:object_class])
          when ?[ then node(:array, class_constant: options[:array_class])
          end
        halt(hjson) if hjson

        begin
          node(:object, without_braces: true)
        rescue SyntaxError
          reset && node(:value)
        end
      end

      def initialize(buffer, **options)
        @buffer  = buffer
        @options = options
      end
    end
  end
end
