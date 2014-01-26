require 'spec_helper'

describe MicroKanren::Lisp do
  include MicroKanren::Lisp

  describe "#car" do
    it "returns the first element in the pair" do
      car(cons(1, 2)).must_equal 1
    end
  end

  describe "#cdr" do
    it "returns the second item in the pair" do
      cdr(cons(1, 2)).must_equal 2
    end
  end

  describe "#cons" do
    it "returns a pair" do
      car(cons(1, 2)).must_equal 1
      cdr(cons(1, 2)).must_equal 2
    end
  end

  describe "#assp" do
    it "returns the first element for which the predicate function is true" do
      alist = cons(1, cons(2, cons(3, 4)))
      assp(->(i) { i == 3 }, alist).must_equal 3
    end
  end

  describe "#ast_to_s" do
    it "prints an expression correctly" do
      c = cons(1, cons(2, cons(cons(3, cons(4, nil)), cons(5, nil))))
      ast_to_s(c).must_equal "(1 2 (3 4) 5)"
    end

    it "prints a cons cell representation of a simple cell" do
      ast_to_s(cons('a', 'b')).must_equal '("a" . "b")'
    end

    it "represents Integers and Floats" do
      ast_to_s(cons(1, 2)).must_equal '(1 . 2)'
    end

    it "prints a nested expression" do
      ast_to_s(cons('a', cons('b', 'c'))).must_equal '("a" "b" . "c")'
    end

    it "represents Arrays (in scheme, vectors) correctly in printed form" do
      ast_to_s(cons('a', [])).must_equal '("a" . [])'
    end

    it "represents nil elements (in scheme, '())" do
      ast_to_s(cons('a', nil)).must_equal '("a")'
    end
  end

  describe "#lists_equal?" do
    it "is true if the lists are equal" do
      lists_equal?(cons(1, cons(2, nil)), cons(1, cons(2, nil))).must_equal true
    end

    it "is false if the lists contain different objects" do
      lists_equal?(cons(1, cons(2, nil)), cons(1, nil)).must_equal false
    end
  end
end
