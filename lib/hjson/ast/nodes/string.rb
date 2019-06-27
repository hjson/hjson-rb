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
      rule(:hex)          { |c| [(?0..?9),(?a..?f),(?A..?F)].include?(c) }

      declare :payload, ''

      parser { fail SyntaxError.new(self) unless double_quote? }
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
        uffff = 4.times.reduce(0) do |i, _|
          read
          fail SyntaxError.new(self) unless hex?
          hex = char.to_i(16)
          break if hex.infinite?
          i * 16 + hex
        end
        uffff.chr(Encoding::UTF_8)
      end
    end
  end
end
