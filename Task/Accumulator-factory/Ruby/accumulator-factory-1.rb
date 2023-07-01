def accumulator(sum)
  lambda {|n| sum += n}
end

# mixing Integer and Float
x = accumulator(1)
x.call(5)
accumulator(3)
puts x.call(2.3)  # prints 8.3
