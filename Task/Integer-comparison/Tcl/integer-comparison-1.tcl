puts "Please enter two numbers:"

gets stdin x
gets stdin y

if { $x > $y } { puts "$x is greater than $y" }
if { $x < $y } { puts "$x is less than $y" }
if { $x == $y } { puts "$x equals $y" }
