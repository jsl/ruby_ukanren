module MicroKanren
  module TestPrograms
    def a_and_b
      a = -> (a) { eq(a, 7) }
      b = -> (b) { disj(eq(b, 5), eq(b, 6)) }

      conj(call_fresh(a), call_fresh(b))
    end

    def fives
      -> (x) {
        disj(eq(x, 5), -> (a_c) { -> { fives(x).call(a_c) } })
      }
    end
  end
end
