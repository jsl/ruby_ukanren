require 'stringio'

# A basic Lisp reader based on Paul Graham's essay:
# http://norvig.com/lispy.html
module Ukanren
  class Reader

    QUOTE  = "'"
    LPAREN = "("
    RPAREN = ")"

    PADDED_LPAREN = " ( "
    PADDED_RPAREN = " ) "

    def initialize(input)
      @input = input
    end

    def tokenize
      @input.gsub(LPAREN, PADDED_LPAREN).gsub(RPAREN, PADDED_RPAREN).split
    end

    def read_tokens(toks = tokenize)
      raise SyntaxError, "No tokens to read!" if toks.empty?
      token = toks.shift

      case token
      when LPAREN
        list = []

        while toks.first != RPAREN
          list << read_tokens(toks)
        end
        toks.shift # shift off RPAREN
        list

      when RPAREN
        raise SyntaxError, "Unexpected RPAREN!"
      else
        atom(token)
      end
    end

    def atom(token)
      begin
        Integer(token)
      rescue ArgumentError
        begin
          Float(token)
        rescue ArgumentError
          token.to_sym
        end
      end
    end
  end
end
