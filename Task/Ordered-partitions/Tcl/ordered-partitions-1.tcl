package require Tcl 8.5
package require struct::set

# Selects all k-sized combinations from a list.
# "Borrowed" from elsewhere on RC
proc selectCombinationsFrom {k l} {
    if {$k == 0} {return {}} elseif {$k == [llength $l]} {return [list $l]}
    set all {}
    set n [expr {[llength $l] - [incr k -1]}]
    for {set i 0} {$i < $n} {} {
        set first [lindex $l $i]
	incr i
        if {$k == 0} {
            lappend all $first
	} else {
	    foreach s [selectCombinationsFrom $k [lrange $l $i end]] {
		lappend all [list $first {*}$s]
	    }
        }
    }
    return $all
}

# Construct the partitioning of a given list
proc buildPartitions {lst n args} {
    # Base case when we have no further partitions to process
    if {[llength $args] == 0} {
	return [list [list $lst]]
    }
    set result {}
    set c [selectCombinationsFrom $n $lst]
    if {[llength $c] == 0} {set c [list $c]}
    foreach comb $c {
	# Sort necessary for "nice" order
	set rest [lsort -integer [struct::set difference $lst $comb]]
	foreach p [buildPartitions $rest {*}$args] {
	    lappend result [list $comb {*}$p]
	}
    }
    return $result
}

# Wrapper that assembles the initial list and calls the partitioner
proc partitions args {
    set sum [tcl::mathop::+ {*}$args]
    set startingSet {}
    for {set i 1} {$i <= $sum} {incr i} {
	lappend startingSet $i
    }

    return [buildPartitions $startingSet {*}$args]
}
