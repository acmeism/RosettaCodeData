set ε 1.0e-15
set fact 1
set e 2.0
set e0 0.0
set n 2

while {[expr abs($e - $e0)] > ${ε}} {
  set e0 $e
  set fact [expr $fact * $n]
  incr n
  set e [expr $e + 1.0/$fact]
}
puts "e = $e"
