require 'spec_helper'

describe MicroKanren::MiniKanrenWrappers do
  include MicroKanren::MiniKanrenWrappers
  include MicroKanren::Lisp

  describe "#pull" do
    it "advances the stream until it matures" do
      stream = -> { -> { 42 } }
      pull(stream).must_equal 42
    end

    it "returns nil in the case of the empty stream" do
      pull(nil).must_be_nil
    end
  end
end
