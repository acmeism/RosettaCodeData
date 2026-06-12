proc cycleSort {listVar} {
    upvar 1 $listVar array
    set writes 0

    # Loop through the array to find cycles to rotate.
    for {set cycleStart 0} {$cycleStart < [llength $array]} {incr cycleStart} {
	set item [lindex $array $cycleStart]

	# Find where to put the item.
	set pos $cycleStart
	for {set i [expr {$pos + 1}]} {$i < [llength $array]} {incr i} {
	    incr pos [expr {[lindex $array $i] < $item}]
	}

	# If the item is already there, this is not a cycle.
	if {$pos == $cycleStart} continue

	# Otherwise, put the item there or right after any duplicates.
	while {$item == [lindex $array $pos]} {
	    incr pos
	}
	set tmp [lindex $array $pos]
	lset array $pos $item
	set item $tmp
	incr writes

	# Rotate the rest of the cycle.
	while {$pos != $cycleStart} {
	    # Find where to put the item.
	    set pos $cycleStart

	    for {set i [expr {$cycleStart + 1}]} {$i < [llength $array]} {incr i} {
		incr pos [expr {[lindex $array $i] < $item}]
	    }

	    # Put the item there or right after any duplicates.
	    while {$item == [lindex $array $pos]} {
		incr pos
	    }
	    set tmp [lindex $array $pos]
	    lset array $pos $item
	    set item $tmp
	    incr writes
	}
    }

    return $writes
}
