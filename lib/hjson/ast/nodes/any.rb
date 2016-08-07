module Hjson
  module AST
    class Any < Node
      rule(:eol)        { |c| [?\r, ?\n, nil].include?(c)  }
      rule(:number)     { |c| (?0..?9).include?(c)         }
      rule(:comment)    { |c| c == ?/ && (peek(1) == ?/ || peek(1) == ?*) }
      rule(:special)    { |c| [?,, ?}, ?], ?#].include?(c) }
      rule(:punctuator) { |c| [?{, ?}, ?[, ?], ?,, ?:].include?(c) }
      rule(:multiline)  { |c| payload.length == 3 && payload == "'''" }

      declare :payload, :char

      parser do
        if punctuator?
          fail SyntaxError, 'Any value does not expected %p' % char
        end
      end
      parser do
        until eos?
          read
          halt(node(:multiline)) if multiline?
          if eol? || special? || comment?
            chf = payload[0]
            stripped = payload.strip
            case chf
            when ?f then halt(false) if stripped == 'false'
            when ?n then halt(nil)   if stripped == 'null'
            when ?t then halt(true)  if stripped == 'true'
            else
              if chf == ?- || number?(chf)
                number = NumberParser.new(payload).parse
                halt(number) if number
              end
            end
            halt(payload.strip) if eol?
          end
          payload << char if char
        end
      end
    end
  end
end
