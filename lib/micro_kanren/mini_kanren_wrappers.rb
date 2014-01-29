module MicroKanren
  module MiniKanrenWrappers
    include Lisp

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
