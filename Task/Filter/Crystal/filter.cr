arr   = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

puts "1. arr = #{arr}"

evens = arr.select {|element| element.even? }
# short form:
evens = arr.select &.even?

puts "   select evens: #{evens}"
puts "   arr = #{arr}"
puts
puts "2. arr = #{arr}"

arr.select! &.even?

puts "   select evens (destructively)"
puts "   arr = #{arr}"
