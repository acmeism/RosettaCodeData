puts "Please enter two numbers:"

set x [expr {int([gets stdin])}]; # Force integer interpretation
set y [expr {int([gets stdin])}]; # Force integer interpretation

puts "$x + $y = [expr {$x + $y}]"
puts "$x - $y = [expr {$x - $y}]"
puts "$x * $y = [expr {$x * $y}]"
puts "$x / $y = [expr {$x / $y}]"
puts "$x mod $y = [expr {$x % $y}]"
puts "$x 'to the' $y = [expr {$x ** $y}]"
