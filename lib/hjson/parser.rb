require 'hjson/ast/parser'
require 'hjson/ast/node'

module Hjson
  class Parser < AST::Node
    parser { node(:root) }

    def initialize(source, **options)
      @source  = source
      @buffer  = StringScanner.new(source)
      @options = options
    end

    private

    def node(*args)
      args.push(**@options)
      super(*args)
    end
  end
end
