proc ids n {
    while {$n != 1 && $n != 89} {
	for {set m 0} {$n} {set n [expr {$n / 10}]} {
	    incr m [expr {($n%10)**2}]
	}
	set n $m
    }
    return $n
}
for {set i 1} {$i <= 100000000} {incr i} {
    incr count [expr {[ids $i] == 89}]
}
puts $count
