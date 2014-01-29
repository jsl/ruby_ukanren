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

    def appendo2
      -> (l, s, out) {
        disj(
          conj(eq(nil, l), eq(s, out)),
          call_fresh(-> (a) {
            call_fresh(-> (d) {
              conj(
                eq(cons(a, d), l),
                call_fresh(-> (res) {
                  conj(
                    -> (s_c) {
                      -> { appendo2.call(d, s, res).call(s_c) }
                    },
                    eq(cons(a, res), out))}))})}))}
    end

    def call_appendo
      call_fresh(-> (q) {
        call_fresh(-> (l) {
          call_fresh(-> (s) {
            call_fresh(-> (out) {
              conj(
                appendo.call(l, s, out),
                eq(cons(l, cons(s, cons(out, nil))), q))})})})})
    end

    def call_appendo2
      call_fresh(-> (q) {
        call_fresh(-> (l) {
          call_fresh(-> (s) {
            call_fresh(-> (out) {
              conj(
                appendo2.call(l, s, out),
                eq(cons(l, cons(s, cons(out, nil))), q))})})})})
    end

    def ground_appendo
      appendo.call(cons(:a, nil), cons(:b, nil), cons(:a, cons(:b, nil)))
    end

    def ground_appendo2
      appendo2.call(cons(:a, nil), cons(:b, nil), cons(:a, cons(:b, nil)))
    end

  end
end
