module Hjson
  module AST
    class Value < Node
      parser { node(:whitespace) }
      parser do
        case char
        when ?{ then node(:object)
        when ?[ then node(:array)
        when ?" then node(:string)
        else node(:any)
        end
      end
    end
  end
end
