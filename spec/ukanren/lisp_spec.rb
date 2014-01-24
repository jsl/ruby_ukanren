require 'spec_helper'

describe Ukanren::Lisp do
  include Ukanren::Lisp

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
end
