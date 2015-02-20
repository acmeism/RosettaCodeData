proc properDivisors {n} {
    if {$n == 1} return
    set divs 1
    set sum 1
    for {set i 2} {$i*$i <= $n} {incr i} {
	if {!($n % $i)} {
	    lappend divs $i
	    incr sum $i
	    if {$i*$i < $n} {
		lappend divs [set d [expr {$n / $i}]]
		incr sum $d
	    }
	}
    }
    return [list $sum $divs]
}

proc amicablePairs {limit} {
    set result {}
    set sums [set divs {{}}]
    for {set n 1} {$n < $limit} {incr n} {
	lassign [properDivisors $n] sum d
	lappend sums $sum
	lappend divs [lsort -integer $d]
    }
    for {set n 1} {$n < $limit} {incr n} {
	set nsum [lindex $sums $n]
	for {set m 1} {$m < $n} {incr m} {
	    if {$n==[lindex $sums $m] && $m==$nsum} {
		lappend result $m $n [lindex $divs $m] [lindex $divs $n]
	    }
	}
    }
    return $result
}

foreach {m n md nd} [amicablePairs 20000] {
    puts "$m and $n are an amicable pair with these proper divisors"
    puts "\t$m : $md"
    puts "\t$n : $nd"
}
