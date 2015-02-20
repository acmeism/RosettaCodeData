package require math::numtheory

proc isSemiprime n {
    if {!($n & 1)} {
	return [::math::numtheory::isprime [expr {$n >> 1}]]
    }
    for {set i 3} {$i*$i < $n} {incr i 2} {
	if {$n / $i * $i != $n && [::math::numtheory::isprime $i]} {
	    if {[::math::numtheory::isprime [expr {$n/$i}]]} {
		return 1
	    }
	}
    }
    return 0
}

for {set n 1675} {$n <= 1680} {incr n} {
    puts -nonewline "$n is ... "
    if {[isSemiprime $n]} {
	puts "a semiprime"
    } else {
	puts "NOT a semiprime"
    }
}
