require "complex"

a = Complex.new(1, 2)
b = 3 + 4.i

puts "a = #{a}, b = #{b}"
puts
puts "a + b = #{a + b}"
puts "a - b = #{a - b}"
puts "a * b = #{a * b}"
puts "a / b = #{a / b}"
puts
puts "-a  = #{-a}"
puts "1/a = #{a.inv}"
puts "ā   = #{a.conj}"
