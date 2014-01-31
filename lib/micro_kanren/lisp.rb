module MicroKanren
  module Lisp

    def cons(x, y)
      Cons.new(x, y)
    end

    def car(z)    ; z.instance_variable_get(:@car)    ; end
    def cdr(z)    ; z.instance_variable_get(:@cdr)    ; end

    def cons?(d)
      d.is_a?(MicroKanren::Cons)
    end
    alias :pair? :cons?

    def map(func, list)
      cons(func.call(car(list)), map(func, cdr(list))) if list
    end

    def length(list)
      list.nil? ? 0 : 1 + length(cdr(list))
    end

    # This function returns a boolean identically to the
    # Scheme procedure? function to avoid false positives.
    def procedure?(elt)
      elt.is_a?(Proc)
    end

    # Search association list by predicate function.
    # Based on lua implementation by silentbicycle:
    # https://github.com/silentbicycle/lua-ukanren/blob/master/ukanren.lua#L53:L61
    #
    # Additional reference for this function is scheme:
    # Ref for assp: http://www.r6rs.org/final/html/r6rs-lib/r6rs-lib-Z-H-4.html
    def assp(func, alist)
      if alist
        first_pair  = car(alist)
        first_value = car(first_pair)

        if func.call(first_value)
          first_pair
        else
          assp(func, cdr(alist))
        end
      else
        false
      end
    end

    def lists_equal?(a, b)
      if cons?(a) && cons?(b)
        lists_equal?(car(a), car(b)) && lists_equal?(cdr(a), cdr(b))
      else
        a == b
      end
    end

  end
end
