proc I {rank {zero 0.0} {one 1.0}} {
    set m [lrepeat $rank [lrepeat $rank $zero]]
    for {set i 0} {$i < $rank} {incr i} {
	lset m $i $i $one
    }
    return $m
}
