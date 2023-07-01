package require struct::set

proc consolidate {sets} {
    if {[llength $sets] < 2} {
	return $sets
    }

    set r [list {}]
    set r0 [lindex $sets 0]
    foreach x [consolidate [lrange $sets 1 end]] {
	if {[struct::set size [struct::set intersect $x $r0]]} {
	    struct::set add r0 $x
	} else {
	    lappend r $x
	}
    }
    return [lset r 0 $r0]
}
