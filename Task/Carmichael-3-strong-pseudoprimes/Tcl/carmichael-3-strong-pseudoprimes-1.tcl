proc carmichael {limit {rounds 10}} {
    set carmichaels {}
    for {set p1 2} {$p1 <= $limit} {incr p1} {
	if {![miller_rabin $p1 $rounds]} continue
	for {set h3 2} {$h3 < $p1} {incr h3} {
	    set g [expr {$h3 + $p1}]
	    for {set d 1} {$d < $h3+$p1} {incr d} {
		if {(($h3+$p1)*($p1-1))%$d != 0} continue
		if {(-($p1**2))%$h3 != $d%$h3} continue

		set p2 [expr {1 + ($p1-1)*$g/$d}]
		if {![miller_rabin $p2 $rounds]} continue

		set p3 [expr {1 + $p1*$p2/$h3}]
		if {![miller_rabin $p3 $rounds]} continue

		if {($p2*$p3)%($p1-1) != 1} continue
		lappend carmichaels $p1 $p2 $p3 [expr {$p1*$p2*$p3}]
	    }
	}
    }
    return $carmichaels
}
