set 1to5 {1 2 3 4 5}

puts [fold {{a b} {expr {$a+$b}}} 0 $1to5]
puts [fold {{a b} {expr {$a*$b}}} 1 $1to5]
puts [fold {{a b} {return $a,$b}} x $1to5]
