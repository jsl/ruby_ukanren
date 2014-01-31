module MicroKanren
  class Cons
    include Lisp

    # Returns a Cons cell (read: instance) that is also marked as such for later identification.
    def initialize(car, cdr)
      @car, @cdr = car, cdr
    end

    # Converts Lisp AST to a String. Algorithm is a recursive implementation of
    # http://www.mat.uc.pt/~pedro/cientificos/funcional/lisp/gcl_22.html#SEC1238.
    def to_s(cons_in_cdr = false)
      str = cons_in_cdr ? '' : '('

      str += cons?(car(self)) ? car(self).to_s : atom_string(car(self))

      str += if cons?(cdr(self))
        ' ' + cdr(self).to_s(true)
      elsif cdr(self).nil?
        ''
      else
        ' . ' + atom_string(cdr(self))
      end

      cons_in_cdr ? str : str << ')'
    end

    private

    def atom_string(node)
      case node
      when NilClass, Array, String
        node.inspect
      else
        node.to_s
      end
    end
  end
end
