proc orderDisjoint {theList theOrderList} {
    foreach item $theOrderList {incr n($item)}
    set is -
    set i 0
    foreach item $theList {
	if {[info exist n($item)] && [incr n($item) -1] >= 0} {
	    lappend is $i
	}
	incr i
    }
    set i 0
    foreach item $theOrderList {
	if {[incr n($item)] <= 1} {
	    lset theList [lindex $is [incr i]] $item
	}
    }
    return $theList
}
