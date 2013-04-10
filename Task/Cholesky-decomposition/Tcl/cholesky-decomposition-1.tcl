proc cholesky a {
    set m [llength $a]
    set n [llength [lindex $a 0]]
    set l [lrepeat $m [lrepeat $n 0.0]]
    for {set i 0} {$i < $m} {incr i} {
	for {set k 0} {$k < $i+1} {incr k} {
	    set sum 0.0
	    for {set j 0} {$j < $k} {incr j} {
		set sum [expr {$sum + [lindex $l $i $j] * [lindex $l $k $j]}]
	    }
	    lset l $i $k [expr {
		$i == $k
		? sqrt([lindex $a $i $i] - $sum)
		: (1.0 / [lindex $l $k $k] * ([lindex $a $i $k] - $sum))
	    }]
	}
    }
    return $l
}
