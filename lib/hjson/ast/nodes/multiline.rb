module Hjson
  module AST
    class Multiline < Node
      attr_accessor :triple, :indent

      rule(:single_quote) { |c| c == ?' }
      rule(:double_quote) { |c| c == ?" }
      rule(:new_line)     { |c| c == ?\n }

      declare :triple,  0
      declare :indent,  0
      declare :payload, ''

      parser do
        loop do
          current = peek(-@indent - 4)
          break if !current || current == ?\n
          self.indent += 1
        end
      end

      parser { read_while { char <= ' ' && !new_line? } }
      parser { read && skip_indent if new_line? }

      parser do
        loop do
          fail SyntaxError unless char
          if single_quote?
            self.triple += 1
            read
            if triple == 3
              @payload = payload.slice(0..-2) if payload.slice(-1) == ?\n
              halt(payload)
            else
              next
            end
          else
            while triple > 0
              payload << ?'
              self.triple -= 1
            end
          end

          if new_line?
            payload << ?\n
            read
            skip_indent
          else
            payload << char if char != ?\r
            read
          end
        end
      end

      private

      def skip_indent
        skip = self.indent
        read_while do
          cond = char <= ' ' && !new_line?
          if cond
            result = skip > 0
            skip -= 1
            result
          end
        end
      end
    end
  end
end
