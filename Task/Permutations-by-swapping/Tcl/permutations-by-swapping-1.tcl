# A simple swap operation
proc swap {listvar i1 i2} {
    upvar 1 $listvar l
    set tmp [lindex $l $i1]
    lset l $i1 [lindex $l $i2]
    lset l $i2 $tmp
}

proc permswap {n v1 v2 body} {
    upvar 1 $v1 perm $v2 sign

    # Initialize
    set sign -1
    for {set i 0} {$i < $n} {incr i} {
	lappend items $i
	lappend dirs -1
    }

    while 1 {
	# Report via callback
	set perm $items
	set sign [expr {-$sign}]
	uplevel 1 $body

	# Find the largest mobile integer (lmi) and its index (idx)
	set i [set idx -1]
	foreach item $items dir $dirs {
	    set j [expr {[incr i] + $dir}]
	    if {$j < 0 || $j >= [llength $items]} continue
	    if {$item > [lindex $items $j] && ($idx == -1 || $item > $lmi)} {
		set lmi $item
		set idx $i
	    }
	}

	# If none, we're done
	if {$idx == -1} break

	# Swap the largest mobile integer with "what it is looking at"
	set nextIdx [expr {$idx + [lindex $dirs $idx]}]
	swap items $idx $nextIdx
	swap dirs $idx $nextIdx

	# Reverse directions on larger integers
	set i -1
	foreach item $items dir $dirs {
	    lset dirs [incr i] [expr {$item > $lmi ? -$dir : $dir}]
	}
    }
}
