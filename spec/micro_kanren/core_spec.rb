require 'spec_helper'

describe MicroKanren::Core do
  include MicroKanren::Core
  include MicroKanren::MiniKanrenWrappers

  describe "#call_fresh" do
    it "second-set t1" do
      res = call_fresh(-> (q) { eq(q, 5) }).call(empty_state)

      # The result should be ((([0] . 5 )) . 1)) following the reference
      # implementation:
      # https://github.com/jasonhemann/microKanren/blob/master/microKanren-test.scm#L6

      # We don't have a pretty printer for our lambda-conses, so here goes:
      car(car(car(car(res)))).must_equal [0]
      cdr(car(res)).must_equal 1
      cdr(car(car(car(res)))).must_equal 5
    end

    it "second-set t2" do
      res = call_fresh(-> (q) { eq(q, 5) }).call(empty_state)

      # Following reference implementation:
      # https://github.com/jasonhemann/microKanren/blob/master/microKanren-test.scm#L11
      cdr(res).must_be_nil
    end

    def a_and_b
      a = -> (a) { eq(a, 7) }
      b = -> (b) { disj(eq(b, 5), eq(b, 6)) }

      conj(call_fresh(a), call_fresh(b))
    end

    it "second-set t3" do
      res = a_and_b.call(empty_state)

      # The result should be ((([1] . 5) ([0] . 7)) . 2)) following the reference
      # implementation:
      # https://github.com/jasonhemann/microKanren/blob/master/microKanren-test.scm#L13
      car(car(car(car(res)))).must_equal [1]
      cdr(car(car(car(res)))).must_equal 5
      car(car(cdr(car(car(res))))).must_equal [0]
      cdr(car(cdr(car(car(res))))).must_equal 7
      cdr(car(res)).must_equal 2
    end

    def fives
      -> (x) {
        disj(eq(x, 5), -> (a_c) { -> { fives(x).call(a_c) } })
      }
    end

    it "who cares" do
      # skip("Create proper assertion for this test")
      res = call_fresh(-> (q) { fives.call(q) }).call(empty_state)
    end

  end
end
