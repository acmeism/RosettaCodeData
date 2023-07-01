package require Tcl 8.5
proc disjointSort {values indices args} {
    # Ensure that we have a unique list of integers, in order
    # We assume there are no end-relative indices
    set indices [lsort -integer -unique $indices]
    # Map from those indices to the values to sort
    set selected {}
    foreach i $indices {lappend selected [lindex $values $i]}
    # Sort the values (using any extra options) and write back to the list
    foreach i $indices v [lsort {*}$args $selected] {
	lset values $i $v
    }
    # The updated list is the result
    return $values
}
