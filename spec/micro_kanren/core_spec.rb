require 'spec_helper'

describe MicroKanren::Core do
  include MicroKanren::Core
  include MicroKanren::MiniKanrenWrappers
  include MicroKanren::Lisp

  describe "#call_fresh" do
    it "second-set t1" do
      res = call_fresh(-> (q) { eq(q, 5) }).call(empty_state)

      # The result should be ((([0] . 5 )) . 1)) following the reference
      # implementation:
      # https://github.com/jasonhemann/microKanren/blob/master/microKanren-test.scm#L6

      expected = ary_to_sexp([[[[MicroKanren::Var.new([0]), 5]], 1]])

      lists_equal?(res, expected).must_equal true
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
      res = car(a_and_b.call(empty_state))

      # The result should be ((([1] . 5) ([0] . 7)) . 2)) following the reference
      # implementation:
      # https://github.com/jasonhemann/microKanren/blob/master/microKanren-test.scm#L13
      expected =
        ary_to_sexp([[[MicroKanren::Var.new([1]), 5], [[MicroKanren::Var.new([0]), 7]]], 2])

      lists_equal?(res, expected).must_equal true
    end

    def fives
      -> (x) {
        disj(eq(x, 5), -> (a_c) { -> { fives(x).call(a_c) } })
      }
    end

    it "who cares" do
      res = take(1, call_fresh(-> (q) { fives.call(q) }).call(empty_state))
      expected_ast = cons(cons(cons(cons([0], 5), nil), 1), nil)
      lists_equal?(res, expected_ast).must_equal true
    end

  end
end
