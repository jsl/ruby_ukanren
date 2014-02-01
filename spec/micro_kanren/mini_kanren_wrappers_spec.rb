require 'spec_helper'

describe MicroKanren::MiniKanrenWrappers do

  include MicroKanren::MiniKanrenWrappers

  # Mostly doing this because some of the methods in MicroKanren::MiniKanrenWrappers
  # interfere with Minitest methods (eg, #run).
  # mk = Class.new.extend(MicroKanren::MiniKanrenWrappers)

  describe "#pull" do
    it "advances the stream until it matures" do
      stream = -> { -> { 42 } }
      pull(stream).must_equal 42
    end

    it "returns nil in the case of the empty stream" do
      pull(nil).must_be_nil
    end
  end

  def appendo(l, s, out)
    term1 = eq()
    conde()
    if l.nil?
      eq(nil, l).call(eq(s, out))
    else
      to_fresh_list = list(:a, :d, :res)
      to_fresh_args = [eq(cons(:a, :d), l),
                       eq(cons(:a, :res), out),
                       appendo(:d, s, :res)]

      fresh(to_fresh_list, *to_fresh_args)
    end
  end

  describe "#run_star" do
    it "returns the correct result" do
      res = run_star(list(:q),
                     fresh(list(:x, :y),
                     eq(list(:x, :y), :q)),
                     appendo(:x, :y, list(1, 2, 3, 4, 5)))
      puts "got #{res.inspect}"
    end
  end
end
