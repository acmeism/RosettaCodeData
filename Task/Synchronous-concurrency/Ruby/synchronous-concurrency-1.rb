count = 0
IO.foreach("input.txt") { |line| print line; count += 1 }
puts "Printed #{count} lines."
