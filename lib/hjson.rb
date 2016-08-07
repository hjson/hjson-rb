require "hjson/version"
require "hjson/parser"

module Hjson
  def parser
    @parser ||= Parser
  end

  def parse(source, **options)
    parser.new(source, **options).parse
  end

  module_function :parser, :parse
end
