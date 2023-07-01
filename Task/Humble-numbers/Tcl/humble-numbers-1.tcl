proc humble? x {
   foreach f {2 3 5 7} {
      while {$x % $f == 0} {set x [expr {$x / $f}]}
   }
   return [expr {$x == 1}]
}
set t1 {}
for {set i 1} {[llength $t1] < 50} {incr i} {
   if [humble? $i] {lappend t1 $i}
}
puts $t1
