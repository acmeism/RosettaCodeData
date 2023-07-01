class Empty
end

e = Empty.new
class << e
  attr_accessor :foo
end
e.foo = 1
puts e.foo  # output: "1"

f = Empty.new
f.foo = 1   # raises NoMethodError
