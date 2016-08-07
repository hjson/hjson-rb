module Hjson
  Error           = Class.new(StandardError)
  SyntaxError     = Class.new(Error)
  EndOfInputError = Class.new(Error)
end
