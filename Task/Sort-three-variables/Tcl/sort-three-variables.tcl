set x {lions, tigers, and}
set y {bears, oh my!}
set z {(from the "Wizard of OZ")}

lassign [lsort [list $x $y $z]] x y z

puts "x: $x"
puts "y: $y"
puts "z: $z"


set x 77444
set y -12
set z 0

lassign [lsort [list $x $y $z]] x y z

puts "x: $x"
puts "y: $y"
puts "z: $z"
