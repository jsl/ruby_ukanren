module MicroKanren
  module Core
    include Lisp

    def var(*c)       ; Var.new(c)   ; end
    def var?(x)       ; x.is_a?(Var) ; end

    # var=? in Scheme implementation.
    def vars_eq?(x1, x2) ; x1[0] == x2[0]  ; end

    # Walk environment S and look up value of U, if present.
    def walk(u, s)
      if var?(u)
        pr = assp(-> (v) { u == v }, s)
        pr ? walk(cdr(pr), s) : u

      else
        u
      end
    end

    def ext_s(x, v, s)
      cons(cons(x, v), s)
    end

    # Constrain u to be equal to v.
    # == in Scheme implementation, ≡ in uKanren papers.
    def eq(u, v)
      ->(s_c) {
        s = unify(u, v, car(s_c))
        s ? unit(cons(s, cdr(s_c))) : mzero
      }
    end

    def unit(s_c) ; cons(s_c, mzero) ; end
    def mzero ; nil ; end

    def unify(u, v, s)
      u = walk(u, s)
      v = walk(v, s)

      if var?(u) && var?(v) && vars_eq?(u, v)
        s

      elsif var?(u)
        ext_s(u, v, s)

      elsif var?(v)
        ext_s(v, u, s)

      elsif pair?(u) && pair?(v)
        s = unify(car(u), car(v), s)
        s && unify(cdr(u), cdr(v), s)

      else
        # Object identity (equal?) seems closest to eqv? in Scheme.
        u.equal?(v) && s
      end
    end

    # Call function f with a fresh variable.
    def call_fresh(f)
      -> (s_c) {
        c = cdr(s_c)
        f.call(var(c)).call(cons(car(s_c), c + 1))
      }
    end

    def disj(g1, g2)
      -> (s_c) { mplus(g1.call(s_c), g2.call(s_c)) }
    end

    def conj(g1, g2)
      -> (s_c) { bind(g1.call(s_c), g2) }
    end

    def mplus(d1, d2)
      if d1.nil?
        d2
      elsif procedure?(d1)
        -> { mplus(d2, d1.call) }
      else
        cons(car(d1), mplus(cdr(d1), d2))
      end
    end

    def bind(d, g)
      if d.nil?
        mzero
      elsif procedure?(d)
        -> { bind(d.call, g) }
      else
        mplus(g.call(car(d)), bind(cdr(d), g))
      end
    end

  end
end
