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

# (define (take n $)
#   (if (zero? n) '()
#     (let (($ (pull $)))
#       (if (null? $) '() (cons (car $) (take (- n 1) (cdr $)))))))

  describe "#take" do
    it "takes the specified number of items from the stream" do
      skip("maybe I'm testing this wrong :(")
      list = cons(1, ->{ 42 })

      result = take(1, list)
      # puts ast_to_s(result)

      car(result).must_equal 1
      cdr(result).must_equal 42
    end
  end
end
