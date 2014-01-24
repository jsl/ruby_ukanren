require 'spec_helper'

describe Ukanren::Reader do
  it "should recognize a simple list" do
    Ukanren::Reader.new("(a (b c))").read_tokens.must_equal [:a, [:b, :c]]
  end

  it "should raise an exception with an invalid list literal" do
    -> { Ukanren::Reader.new(")(").read_tokens }.must_raise SyntaxError
  end

  it "should raise an exception with an empty list literal" do
    -> { Ukanren::Reader.new('').read_tokens }.must_raise SyntaxError
  end
end
