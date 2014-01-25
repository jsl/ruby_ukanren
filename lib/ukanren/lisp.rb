module Ukanren
  module Lisp

    # Returns a Cons cell that is also marked as such for later identification.
    def cons(x, y)
      -> (m) { m.call(x, y) }.tap do |func|
        func.instance_eval{ def cons_cell? ; true ; end }
      end
    end

    def car(z)     ; z.call(-> (p, q) { p }) ; end
    def cdr(z)     ; z.call(-> (p, q) { q }) ; end

    def cons_cell?(d)
      d.respond_to?(:cons_cell?) && d.cons_cell?
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
    # Procs.
    def print_ast(node)
      if cons_cell?(node)
        ['(', print_ast(car(node)), ' . ', print_ast(cdr(node)), ')'].join
      else
        case node
        when NilClass, Array, String
          node.inspect
        else
          node.to_s
        end
      end
    end
  end
end
