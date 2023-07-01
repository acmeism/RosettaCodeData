set q [Q new 1 2 3 4]
set q1 [Q new 2 3 4 5]
set q2 [Q new 3 4 5 6]
set r 7

puts "q = [$q p]"
puts "q1 = [$q1 p]"
puts "q2 = [$q2 p]"
puts "r = $r"
puts "q norm = [$q norm]"
puts "q1 norm = [$q1 norm]"
puts "q2 norm = [$q2 norm]"
puts "-q = [[$q -] p]"
puts "q conj = [[$q conjugate] p]"
puts "q + r = [[$q + $r] p]"
# Real numbers are not objects, so no extending operations for them
puts "q1 + q2 = [[$q1 + $q2] p]"
puts "q2 + q1 = [[$q2 + $q1] p]"
puts "q * r = [[$q * $r] p]"
puts "q1 * q2 = [[$q1 * $q2] p]"
puts "q2 * q1 = [[$q2 * $q1] p]"
puts "equal(q1*q2, q2*q1) = [[$q1 * $q2] == [$q2 * $q1]]"
