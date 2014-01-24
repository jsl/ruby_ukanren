require 'spec_helper'

describe Ukanren::Language do
  include Ukanren::Language

  def a_and_b
    a = -> (a) { eq(a, 7) }
    b = -> (b) { disj(eq(b, 5), eq(b, 6)) }

    conj(call_fresh(a), call_fresh(b))
  end

  describe "#call_fresh" do
    it "second-set t1" do
      call_fresh(-> (q) { eq(q, 5) }).call(empty_env)
    end

    it "second-set t3" do
      a_and_b.call(empty_env)
    end
  end
end
