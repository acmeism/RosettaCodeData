package require Tcl 8.6

# A sort that works by sorting by an auxiliary key computed by a lambda term
proc sortByFunction {list lambda} {
    lmap k [lsort -index 1 [lmap k $list {
	list $k [uplevel 1 [list apply $lambda $k]]
    }]] {lindex $k 0}
}

# A simple way to pick a “best” item from a list
proc minimax {list maxidx minidx} {
    set max -Inf; set min Inf
    foreach t $list {
	if {[set m [lindex $t $maxidx]] > $max} {
	    set best $t
	    set max $m
	    set min Inf
	} elseif {$m == $max && [set m [lindex $t $minidx]] < $min} {
	    set best $t
	    set min $m
	}
    }
    return $best
}

# The approximation engine. Note that this does not change the provided
# arguments at all since they are copied on write.
proc VAM {costs demand supply} {
    # Initialise the sorted sequence of pairs and the result dictionary
    foreach x [dict keys $demand] {
	dict set g $x [sortByFunction [dict keys $supply] {g {
	    upvar 1 costs costs x x; dict get $costs $g $x
	}}]
	dict set row $x 0
    }
    foreach x [dict keys $supply] {
	dict set g $x [sortByFunction [dict keys $demand] {g {
	    upvar 1 costs costs x x; dict get $costs $x $g
	}}]
	dict set res $x $row
    }

    # While there's work to do...
    while {[dict size $g]} {
	# Select "best" demand
	lassign [minimax [lmap x [dict keys $demand] {
	    if {![llength [set gx [dict get $g $x]]]} continue
	    set z [dict get $costs [lindex $gx 0] $x]
	    if {[llength $gx] > 1} {
		list $x $z [expr {[dict get $costs [lindex $gx 1] $x] - $z}]
	    } else {
		list $x $z $z
	    }
	}] 2 1] d dVal dCost

	# Select "best" supply
	lassign [minimax [lmap x [dict keys $supply] {
	    if {![llength [set gx [dict get $g $x]]]} continue
	    set z [dict get $costs $x [lindex $gx 0]]
	    if {[llength $gx] > 1} {
		list $x $z [expr {[dict get $costs $x [lindex $gx 1]] - $z}]
	    } else {
		list $x $z $z
	    }
	}] 2 1] s sVal sCost

	# Compute how much to transfer, and with which "best"
	if {$sCost == $dCost ? $sVal > $dVal : $sCost < $dCost} {
	    set s [lindex [dict get $g $d] 0]
	} else {
	    set d [lindex [dict get $g $s] 0]
	}
	set v [expr {min([dict get $supply $s], [dict get $demand $d])}]

	# Transfer some supply to demand
	dict update res $s inner {dict incr inner $d $v}
	dict incr demand $d -$v
	if {[dict get $demand $d] == 0} {
	    dict for {k n} $supply {
		if {$n != 0} {
		    # Filter list in dictionary to remove element
		    dict set g $k [lmap x [dict get $g $k] {
			if {$x eq $d} continue; set x
		    }]
		}
	    }
	    dict unset g $d
	    dict unset demand $d
	}
	dict incr supply $s -$v
	if {[dict get $supply $s] == 0} {
	    dict for {k n} $demand {
		if {$n != 0} {
		    dict set g $k [lmap x [dict get $g $k] {
			if {$x eq $s} continue; set x
		    }]
		}
	    }
	    dict unset g $s
	    dict unset supply $s
	}
    }
    return $res
}
