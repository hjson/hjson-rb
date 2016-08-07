module Hjson
  module AST
    class Whitespace < Node
      rule(:simple_comment) { |c| c == ?# || (char == ?/ && peek(1) == ?/) }
      rule(:multi_comment)  { |c| c == ?/ && peek(1) == ?* }

      parser do
        until eos?
          read_while { char <= ' ' }
          if simple_comment?
            read_while { char != ?\n }
          elsif multi_comment?
            read
            read_while { !(char == ?* && peek(1) == ?/) }
            current = char
            skip(2) if current
          else
            break
          end
        end
      end

      private

      def skip(n)
        n.times { read }
      end
    end
  end
end
