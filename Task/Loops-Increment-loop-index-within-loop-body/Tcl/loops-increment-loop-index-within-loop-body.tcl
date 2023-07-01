proc isPrime n {
  if {[expr $n % 2] == 0} {
    return [expr $n == 2]
  }
  if {[expr $n % 3] == 0} {
    return [expr $n == 3]
  }
  for {set d 5} {[expr $d * $d] <= $n} {incr d 4} {
    if {[expr $n % $d] == 0} {return 0}
    incr d 2
    if {[expr $n % $d] == 0} {return 0}
  }
  return 1
}

set LIMIT 42

for {set i $LIMIT; set n 0} {$n < $LIMIT} {incr i} {
  if [isPrime $i] {
    incr n
    puts "n=$n, i=$i"
    incr i [expr $i -1]
  }
}
