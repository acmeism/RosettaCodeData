proc squaregen {{i 0}} {
  proc squaregen "{i [incr i]}" [info body squaregen]
  expr $i * $i
}

proc is_cube {n} {
  for {set i 1} {($i * $i * $i) < $n} {incr i} { }
  expr ($i * $i * $i) == $n
}

set cubes {}
set noncubes {}
for {set s [squaregen]} {[llength $noncubes] < 30} {set s [squaregen]} {
  if [is_cube $s] {
    lappend cubes $s
  } else {
    lappend noncubes $s
  }
}
puts "Squares but not cubes:"
puts $noncubes
puts {}
puts "Both squares and cubes:"
puts $cubes
