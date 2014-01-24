require 'spec_helper'

describe Ukanren::Language do
  include Ukanren::Language

  describe "second-set t1" do
    it "returns one binding" do
      call_fresh(-> (q) { eq(q, 5) }).call(empty_env)
    end
  end
end
