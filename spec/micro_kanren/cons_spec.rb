require 'spec_helper'

describe MicroKanren::Cons do
  include MicroKanren::Lisp

  describe "#initialize" do
    it "takes two arguments for car and cdr" do
      MicroKanren::Cons.new(1, 2).must_be_instance_of MicroKanren::Cons
      proc {MicroKanren::Cons.new(1)}.must_raise ArgumentError
    end
  end

  describe "#to_s" do
    it "prints an expression correctly" do
      c = cons(1, cons(2, cons(cons(3, cons(4, nil)), cons(5, nil))))
      c.to_s.must_equal "(1 2 (3 4) 5)"
      d = cons(cons(2, 3), 1)
      d.to_s.must_equal "((2 . 3) . 1)"
      e = cons(1, nil)
      e.to_s.must_equal "(1)"
      # Is this an illogical list to be testing?
      f = cons(nil, 1)
      f.to_s.must_equal "(nil . 1)"
    end

    it "prints a cons cell representation of a simple cell" do
      cons('a', 'b').to_s.must_equal '("a" . "b")'
    end

    it "represents Integers and Floats" do
      cons(1, 2).to_s.must_equal '(1 . 2)'
    end

    it "prints a nested expression" do
      cons('a', cons('b', 'c')).to_s.must_equal '("a" "b" . "c")'
    end

    it "represents Arrays (in scheme, vectors) correctly in printed form" do
      cons('a', []).to_s.must_equal '("a" . [])'
    end

    it "represents nil elements (in scheme, '())" do
      cons('a', nil).to_s.must_equal '("a")'
    end
  end
end
