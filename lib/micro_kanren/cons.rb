module MicroKanren
  class Cons
    attr_reader :car, :cdr

    # Returns a Cons cell (read: instance) that is also marked as such for later identification.
    def initialize(car, cdr)
      @car, @cdr = car, cdr
    end

    # Converts Lisp AST to a String. Algorithm is a recursive implementation of
    # http://www.mat.uc.pt/~pedro/cientificos/funcional/lisp/gcl_22.html#SEC1238.
    def to_s(cons_in_cdr = false)
      str = cons_in_cdr ? '' : '('
      cons?(self.car) ? str += self.car.to_s : str += atom_string(self.car)

      if cons?(self.cdr)
        str += ' ' + self.cdr.to_s(true)
      else
        str += ' . ' + atom_string(self.cdr) unless self.cdr.nil?
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

    def cons?(d)
      d.is_a?(MicroKanren::Cons)
    end
  end
end
