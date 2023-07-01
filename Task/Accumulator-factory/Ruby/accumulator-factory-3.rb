def accumulator(sum)
  lambda {|n| sum += n}
end
class << self
  define_method :x, &accumulator(1)
end
x(5)
accumulator(3)
puts x(2.3)  # prints 8.3
