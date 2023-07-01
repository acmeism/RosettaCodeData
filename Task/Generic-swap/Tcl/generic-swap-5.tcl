set a 1
set b 2
puts "before\ta=$a\tb=$b"
set a $b[set b $a;lindex {}]
puts "after\ta=$a\tb=$b"
