module Hjson
  module AST
    class Object < Node
      rule(:without_braces) { !!@without_braces }
      rule(:finished)       { |c| c == ?} && !without_braces? }
      rule(:comma)          { |c| c == ?, }

      declare(:object_class)   { options[:object_class] || Hash }
      declare(:payload)        { @object_class.new }
      declare(:without_braces) { !!options[:without_braces] }

      parser { read unless without_braces? }
      parser { node(:whitespace) }
      parser { halt(read && payload) if finished? }
      parser do
        while char?
          key = node(:keyname)
          with_whitespaces do
            validate ?:
            read
            payload[key] = node(:value)
          end
          if comma?
            node(:whitespace)
            read 
          end
          halt(read && payload) if finished?
          node(:whitespace)
        end
      end
      parser do
        if without_braces?
          halt(payload)
        else
          fail EndOfInputError
        end
      end
    end
  end
end
