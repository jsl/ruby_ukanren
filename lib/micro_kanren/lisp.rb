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

    def cons?(d)
      d.respond_to?(:ccel?) && d.ccel?
    end
    alias :pair? :cons?

    # We implement scheme cons cells as Procs. This function returns a boolean
    # identically to the Scheme procedure? function to avoid false positives.
    def procedure?(elt)
      elt.is_a?(Proc) && !cons?(elt)
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

    # Turns a Ruby array into an s-expression.
    def ary_to_sexp(ary)
      head = ary[0].is_a?(Array) && !ary[0].is_a?(MicroKanren::Var) ? ary_to_sexp(ary[0]) : ary[0]

      if ary.length > 2
        cons(head, ary_to_sexp(ary[1..-1]))
      else
        tail = ary[1].is_a?(Array) && !ary[0].is_a?(MicroKanren::Var) ? ary_to_sexp(ary[1]) : ary[1]
        cons(head, tail)
      end
    end

    # Converts Lisp AST to a String. Algorithm is a recursive implementation of
    # http://www.mat.uc.pt/~pedro/cientificos/funcional/lisp/gcl_22.html#SEC1238.
    def ast_to_s(node, cons_in_cdr = false)
      if cons?(node)
        str = cons_in_cdr ? '' : '('
        str += ast_to_s(car(node))

        if cons?(cdr(node))
          str += ' ' + ast_to_s(cdr(node), true)
        else
          str += ' . ' + ast_to_s(cdr(node)) unless cdr(node).nil?
        end

        cons_in_cdr ? str : str << ')'
      else
        atom_string(node)
      end
    end

    def lists_equal?(a, b)
      if cons?(a) && cons?(b)
        lists_equal?(car(a), car(b)) && lists_equal?(cdr(a), cdr(b))
      else
        a == b
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
