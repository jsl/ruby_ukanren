module MicroKanren
  module TestSupport

    # Shorthand for declaring a new logic variable.
    def uvar(v)
      MicroKanren::Var.new([v])
    end
  end
end
