module MicroKanren
  module Lisp

    # Returns a Cons cell that is also marked as such for later identification.
    def cons(x, y)
      -> (m) { m.call(x, y) }.tap do |func|
        func.instance_eval{ def ccel? ; true ; end }
      end
    end

    def car(z)     ; z.call(-> (p, q) { p }) ; end
    def cdr(z)     ; z.call(-> (p, q) { q }) ; end

    def cons_cell?(d)
      d.respond_to?(:ccel?) && d.ccel?
    end

    # Search association list by predicate function.
    # Based on lua implementation by silentbicycle:
    # https://github.com/silentbicycle/lua-ukanren/blob/master/ukanren.lua#L53:L61
    #
    # Additional reference for this function is scheme:
    # Ref for assp: http://www.r6rs.org/final/html/r6rs-lib/r6rs-lib-Z-H-4.html
    def assp(func, alist)
      if alist && hd = car(alist)
        func.call(hd) ? hd : assp(func, cdr(alist))
      end
    end

    # A nicer printed representation of nested cons cells represented by Ruby
    # Procs. Algorithm is a recursive implementation of
    # http://www.mat.uc.pt/~pedro/cientificos/funcional/lisp/gcl_22.html#SEC1238
    def ast_to_s(node, cons_in_cdr = false)
      if cons_cell?(node)
        str = cons_in_cdr ? '' : '('
        str += ast_to_s(car(node))

        if cons_cell?(cdr(node))
          str += ' ' + ast_to_s(cdr(node), true)
        else
          str += ' . ' + ast_to_s(cdr(node)) unless cdr(node).nil?
        end

        cons_in_cdr ? str : str << ')'
      else
        atom_string(node)
      end
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
