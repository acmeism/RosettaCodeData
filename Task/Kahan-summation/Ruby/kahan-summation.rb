epsilon = 1.0
epsilon /= 2 until 1.0 + epsilon == 1.0

a = 1.0
b = epsilon
c = -b

puts "epsilon    : #{epsilon}"
puts "(a+b)+c    : #{(a+b)+c}"
puts "[a,b,c].sum: #{[a,b,c].sum}"
