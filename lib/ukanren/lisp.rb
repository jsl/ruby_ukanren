module Ukanren
  module Lisp

    def cons(x, y) ; -> (m) { m.call(x, y) } ; end
    def car(z)     ; z.call(-> (p, q) { p }) ; end
    def cdr(z)     ; z.call(-> (p, q) { q }) ; end

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

  end
end
