module MicroKanren
  class Cons
    attr_reader :car, :cdr

    # Returns a Cons cell (read: instance) that is also marked as such for later identification.
    def initialize(car, cdr)
      @car, @cdr = car, cdr
      self.tap do |func|
        func.instance_eval{ def ccel? ; true ; end }
      end
    end

    def to_s
      # eventually this will be a replacement for lprint from ::Lisp
    end

  end
end
