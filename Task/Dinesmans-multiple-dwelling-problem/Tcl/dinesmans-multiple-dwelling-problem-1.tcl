package require Tcl 8.5
package require struct::list

proc dinesmanSolve {floors people constraints} {
    # Search for a possible assignment that satisfies the constraints
    struct::list foreachperm p $floors {
	lassign $p {*}$people
	set found 1
	foreach c $constraints {
	    if {![expr $c]} {
		set found 0
		break
	    }
	}
	if {$found} break
    }
    # Found something, or exhausted possibilities
    if {!$found} {
	error "no solution possible"
    }
    # Generate in "nice" order
    foreach f $floors {
	foreach person $people {
	    if {[set $person] == $f} {
		lappend result $f $person
		break
	    }
	}
    }
    return $result
}
