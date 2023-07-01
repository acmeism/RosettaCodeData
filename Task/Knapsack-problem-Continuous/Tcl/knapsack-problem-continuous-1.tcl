package require Tcl 8.5

# Uses the trivial greedy algorithm
proc continuousKnapsack {items massLimit} {
    # Add in the unit prices
    set idx -1
    foreach item $items {
	lassign $item name mass value
	lappend item [expr {$value / $mass}]
	lset items [incr idx] $item
    }

    # Sort by unit prices
    set items [lsort -decreasing -real -index 3 $items]

    # Add items, using most valuable-per-unit first
    set result {}
    set total 0.0
    set totalValue 0
    foreach item $items {
	lassign $item name mass value unit
	if {$total + $mass < $massLimit} {
	    lappend result [list $name $mass $value]
	    set total [expr {$total + $mass}]
	    set totalValue [expr {$totalValue + $value}]
	} else {
	    set mass [expr {$massLimit - $total}]
	    set value [expr {$unit * $mass}]
	    lappend result [list $name $mass $value]
	    set totalValue [expr {$totalValue + $value}]
	    break
	}
    }

    # We return the total value too, purely for convenience
    return [list $result $totalValue]
}
