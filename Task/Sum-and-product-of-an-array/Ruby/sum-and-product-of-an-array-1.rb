arr = [1,2,3,4,5]     # or ary = *1..5, or ary = (1..5).to_a
p sum = arr.inject(0) { |sum, item| sum + item }
# => 15
p product = arr.inject(1) { |prod, element| prod * element }
# => 120
