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

    def appendo
      -> (l, s, out) {
        disj(
          conj(eq(nil, l), eq(s, out)),
          call_fresh(-> (a) {
            call_fresh(-> (d) {
              conj(
                eq(cons(a, d), l),
                call_fresh(-> (res) {
                  conj(
                    eq(cons(a, res), out),
                    -> (s_c) {
                      -> {appendo.call(d, s, res).call(s_c)}})}))})}))}
    end

    def ground_appendo
      appendo.call(cons(:a, nil), cons(:b, nil), cons(:a, cons(:b, nil)))
    end
  end
end
