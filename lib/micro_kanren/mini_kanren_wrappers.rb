module MicroKanren
  module MiniKanrenWrappers
    include Lisp

    # Advances a stream until it matures. Per microKanren document 5.2, "From
    # Streams to Lists."
    def pull(stream)
      stream.is_a?(Proc) && !cons_cell?(stream) ? pull(stream.call) : stream
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
  end
end
