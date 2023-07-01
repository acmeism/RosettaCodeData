proc orderDisjoint {theList theOrderList} {
    foreach item $theOrderList {incr n($item)}
    set is {}
    set i 0
    foreach item $theList {
	if {[info exist n($item)] && [incr n($item) -1] >= 0} {
	    lappend is $i
	}
	incr i
    }
    foreach item $theOrderList i $is {lset theList $i $item}
    return $theList
}
