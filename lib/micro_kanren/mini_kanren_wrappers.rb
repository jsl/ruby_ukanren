module MicroKanren
  module MiniKanrenWrappers
    include Core

    def empty_state
      cons(mzero, 0)
    end

    # Advances a stream until it matures. Per microKanren document 5.2, "From
    # Streams to Lists."
    def pull(stream)
      stream.is_a?(Proc) && !cons?(stream) ? pull(stream.call) : stream
    end

    def take(n, stream)
      if n > 0
        if cur = pull(stream)
          cons(car(cur), take(n - 1, cdr(cur)))
        end
      end
    end

    def zzz(g)
      -> (a_c) { -> { g.call(a_c) } }
    end

    def conj_plus(*gs)
      if gs.length == 1
        zzz(gs[0])
      else
        conj(zzz(gs[0]), conj_plus(gs[1..-1]))
      end
    end

    def disj_plus(*gs)
      if length(gs) == 1
        zzz(car(gs))
      else
        disj(zzz(gs[0]), disj_plus(gs[1..-1]))
      end
    end

    def fresh(l, *gs)
      if l.nil?
        conj_plus(*gs)
      else
        x0 = car(l)
        call_fresh(-> (x0) { fresh(cdr(l), *gs)})
      end
    end

    def conde(*gs)
      disj_plus(conj_plus(car(gs, car(cdr(gs)))), l)
    end

    def run_n(n, xs, gs)
      map(method(:reify_1st).to_proc, take(n, call_goal(fresh(x, gs))))
    end

    def run_star(xs, *gs)
      map(method(:reify_1st).to_proc, take_all(call_goal(fresh(xs, *gs))))
    end

    def call_goal(g) ; g.call(empty_state) ; end

    def take_all(stream)
      if cur = pull(stream)
        cons(car(cur), take_all(cdr(cur)))
      end
    end

    def reify_1st(s_c)
      v = walk_star((var 0), car(s_c))
      walk_star(v, reify_s(v, nil))
    end

    def reify_s(v, s)
      v = walk(v, s)
      if var?(v)
        n = reify_name(length(s))
        cons(cons(v, n), s)
      elsif pair?(v)
        reify_s(cdr(v), reify_s(car(v), s))
      else
        s
      end
    end

    def reify_name(n)
      "_.#{n}".to_sym
    end

    def walk_star(v, s)
      v = walk(v, s)
      if var?(v)
        v
      elsif pair?(v)
        cons(walk_star(car(v), s),
             walk_star(cdr(v), s))
      else
        v
      end
    end

  end
end
