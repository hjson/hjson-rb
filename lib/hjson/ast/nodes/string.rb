module Hjson
  module AST
    class String < Node
      ESCAPEE = {
        ?"  => ?",
        ?\\ => ?\\,
        ?/  => ?/,
        ?b  => ?\b,
        ?f  => ?\f,
        ?n  => ?\n,
        ?r  => ?\r,
        ?t  => ?\t
      }.freeze

      rule(:double_quote) { |c| c == ?" }
      rule(:escaped)      { |c| c == ?\\ }
      rule(:unicode)      { |c| c == ?u }
      rule(:escapee)      { |c| !!ESCAPEE[c] }

      declare :payload, ''

      parser { fail SyntaxError unless double_quote? }
      parser do
        while read
          halt(read && payload) if double_quote?
          if escaped?
            read
            if unicode?
              payload << read_unicode
            elsif escapee?
              payload << read_escapee
            else
              break
            end
          else
            payload << char
          end
        end
      end

      private

      def read_escapee
        ESCAPEE[char]
      end

      def read_unicode
        uffff = 4.times.reduce(0) do |uffff, _|
          read
          hex = char.to_i(16)
          break if hex.infinite?
          uffff * 16 + hex
        end
        uffff.chr(Encoding::UTF_8)
      end
    end
  end
end
