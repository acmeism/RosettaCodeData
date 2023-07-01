proc countDivisors {n} {
  if {$n < 2} {return 1}
  set count 2
  set n2 [expr $n / 2]
  for {set i 2} {$i <= $n2} {incr i} {
    if {[expr $n % $i] == 0} {incr count}
  }
  return $count
}

# main
set maxDiv 0
set count 0

puts "The first 20 anti-primes are:"
for {set n 1} {$count < 20} {incr n} {
  set d [countDivisors $n]
  if {$d > $maxDiv} {
    puts $n
    set maxDiv $d
    incr count
  }
}
