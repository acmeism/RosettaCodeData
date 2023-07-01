proc listEquilibria {list} {
    set after 0
    foreach item $list {incr after $item}
    set result {}
    set idx 0
    set before 0
    foreach item $list {
	incr after [expr {-$item}]
	if {$after == $before} {
	    lappend result $idx
	}
	incr before $item
	incr idx
    }
    return $result
}
