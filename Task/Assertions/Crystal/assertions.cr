class AssertionError < Exception
end

def assert(predicate : Bool, msg = "The asserted condition was false")
  raise AssertionError.new(msg) unless predicate
end

assert(12 == 42, "It appears that 12 doesn't equal 42")
