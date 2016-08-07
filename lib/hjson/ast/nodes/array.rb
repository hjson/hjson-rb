module Hjson
  module AST
    class Array < Node
      rule(:comma)    { |c| c == ?, }
      rule(:finished) { |c| c == ?] }

      declare(:array_class) { options[:array_class] || ::Array }
      declare(:payload)     { @array_class.new }

      parser { read && node(:whitespace) }
      parser { halt(read && payload) if finished? }
      parser do
        while char?
          payload << node(:value)
          with_whitespaces do
            read && node(:whitespace) if comma?
            halt(read && payload) if finished?
          end
        end
      end
      parser { fail EndOfInputError }
    end
  end
end
