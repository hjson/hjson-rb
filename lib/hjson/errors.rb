module Hjson
  class Error < StandardError
    def initialize(parser, message = "")
      message.prepend("L#{parser.current_line_number}:#{parser.charpos} ")
      message.strip!

      super(message)
    end
  end

  SyntaxError     = Class.new(Error)
  EndOfInputError = Class.new(Error)
end
