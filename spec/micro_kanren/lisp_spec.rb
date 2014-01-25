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

  describe "#print_ast" do
    it "prints a cons cell representation of a simple cell" do
      print_ast(cons('a', 'b')).must_equal '("a" . "b")'
    end

    it "represents Integers and Floats" do
      print_ast(cons(1, 2)).must_equal '(1 . 2)'
    end

    it "prints a nested expression" do
      print_ast(cons('a', cons('b', 'c'))).must_equal '("a" . ("b" . "c"))'
    end

    it "represents Arrays (in scheme, vectors) correctly in printed form" do
      print_ast(cons('a', [])).must_equal '("a" . [])'
    end

    it "represents nil elements (in scheme, '())" do
      print_ast(cons('a', nil)).must_equal '("a" . nil)'
    end
  end
end
