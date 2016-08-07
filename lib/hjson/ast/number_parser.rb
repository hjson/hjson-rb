require 'hjson/ast/parser'

module Hjson
  module AST
    class NumberParser < Parser
      attr_accessor :leading, :zero_size, :payload

      rule(:zero)        { |c| c == ?0 }
      rule(:symbol)      { |c| negative? || c == ?+ }
      rule(:period)      { |c| c == ?. }
      rule(:number)      { |c| (?0..?9).include?(c) }
      rule(:negative)    { |c| c == ?- }
      rule(:exponential) { |c| c == ?e || c == ?E }

      rule(:leading)      { !!@leading }
      rule(:payload_float) { payload.include?(?.) || payload.include?(?e) || payload.include?(?E) }

      parser { (self.payload = ?-) && read if negative? }

      parser do
        read_while if: :number? do
          if leading?
            if char == ?0
              self.zero_size += 1
            else
              self.leading = false
            end
          end
          payload << char
        end
      end

      parser { self.zero_size -= 1 if leading? }

      parser do
        if period?
          (payload << ?.) && read
          read_while(if: :number?) { payload << char }
        end
      end

      parser do
        if exponential?
          (payload << char) && read
          (payload << char) && read if symbol?
          read_while(if: :number?) { payload << char }
        end
      end

      parser do
        read_while { char <= ' ' }
        halt if char || !zero_size.zero?
        payload.public_send(payload_float? ? :to_f : :to_i)
      end

      def initialize(payload, **options)
        @source    = payload
        @buffer    = StringScanner.new(source)
        @payload   = ''
        @leading   = true
        @zero_size = 0
        @options   = options
      end
    end
  end
end
