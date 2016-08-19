module Hjson
  module AST
    class Keyname < Node
      attr_accessor :start, :space

      rule(:double_quote) { |c| c == ?" }
      rule(:colon) { |c| c == ?: }
      rule(:punctuator) { |c| [?{, ?}, ?[, ?], ?,, ?:].include?(c) }

      declare :space,   -1
      declare :start,   :charpos
      declare :payload, ''

      parser { halt(node(:string)) if double_quote? }
      parser do
        until eos?
          if colon?
            fail SyntaxError if payload.empty?
            if positive?(space) && space != payload.length
              buffer.pos = start + space
              fail SyntaxError
            end
            halt(payload)
          elsif char <= ' '
            fail SyntaxError if eos?
            self.space = payload.length if negative?(space)
          elsif punctuator?
            fail SyntaxError
          else
            payload << char
          end
          read
        end
      end

      private

      def positive?(number)
        number.respond_to?(:positive?) ? number.positive? : (number > 0)
      end

      def negative?(number)
        number.respond_to?(:negative?) ? number.negative? : (number < 0)
      end
    end
  end
end
