# Swap the values at two indices of a list
proc swap {list i j} {
    upvar 1 $list l
    set tmp [lindex $l $i]
    lset l $i [lindex $l $j]
    lset l $j $tmp
}

proc quickselect {vector k {left 0} {right ""}} {
    set last [expr {[llength $vector] - 1}]
    if {$right eq ""} {
	set right $last
    }
    # Sanity assertions
    if {![llength $vector] || $k <= 0} {
	error "Either empty vector, or k <= 0"
    } elseif {![tcl::mathop::<= 0 $left $last]} {
	error "left is out of range"
    } elseif {![tcl::mathop::<= $left $right $last]} {
	error "right is out of range"
    }

    # the _select core, inlined
    while 1 {
	set pivotIndex [expr {int(rand()*($right-$left))+$left}]

	# the partition core, inlined
	set pivotValue [lindex $vector $pivotIndex]
	swap vector $pivotIndex $right
	set storeIndex $left
	for {set i $left} {$i <= $right} {incr i} {
	    if {[lindex $vector $i] < $pivotValue} {
		swap vector $storeIndex $i
		incr storeIndex
	    }
	}
	swap vector $right $storeIndex
	set pivotNewIndex $storeIndex

	set pivotDist [expr {$pivotNewIndex - $left + 1}]
	if {$pivotDist == $k} {
	    return [lindex $vector $pivotNewIndex]
	} elseif {$k < $pivotDist} {
	    set right [expr {$pivotNewIndex - 1}]
	} else {
	    set k [expr {$k - $pivotDist}]
	    set left [expr {$pivotNewIndex + 1}]
	}
    }
}
