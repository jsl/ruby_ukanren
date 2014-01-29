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

  describe "#length" do
    it "returns 0 for an empty list" do
      length(nil).must_equal 0
    end

    it "returns the list length for a non-empty list" do
      length(cons(1, cons(2, nil))).must_equal 2
    end
  end

  describe "#map" do
    it "maps a function over a list" do
      func = -> (str) { str.upcase }
      ast_to_s(map(func, cons("foo", cons("bar", nil)))).must_equal '("FOO" "BAR")'
    end
  end

  describe "#assp" do
    it "returns the first pair for which the predicate function is true" do
      al1 = cons(3, cons(:a, nil))
      al2 = cons(1, cons(:b, nil))
      al3 = cons(4, cons(:c, nil))

      alist = cons(al1, cons(al2, cons(al3, nil)))

      res = assp(->(i) { i.even? }, alist)
      lists_equal?(res, cons(4, cons(:c, nil))).must_equal true
    end

    it "returns false if there is no matching element found" do
      pair1 = cons(3, cons(:a, nil))
      pair2 = cons(1, cons(:b, nil))
      pair3 = cons(4, cons(:c, nil))

      alist = cons(pair1, cons(pair2, cons(pair3, nil)))

      res = assp(->(i) { i == 5 }, alist)
      res.must_equal false
    end
  end

  # http://download.plt-scheme.org/doc/html/reference/pairs.html#(def._((quote._~23~25kernel)._pair~3f))
  describe "#pair?" do
    it "is false for an integer" do
      pair?(1).must_equal false
    end

    it "is true for a list with an int in the car and cdr" do
      pair?(cons(1, 2)).must_equal true
    end

    it "is true for a proper list" do
      pair?(cons(1, cons(2, nil))).must_equal true
    end

    it "is false for an empty list" do
      pair?(nil).must_equal false
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
