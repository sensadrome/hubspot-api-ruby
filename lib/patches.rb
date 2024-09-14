class Object
  unless Object.method_defined?(:yield_self)
    def yield_self
      yield(self)
    end
  end
end
