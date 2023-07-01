package require Tcl 8.6

proc patienceSort {items} {
    # Make the piles
    set piles {}
    foreach item $items {
	set p [lsearch -bisect -index end $piles $item]
	if {$p == -1} {
	    lappend piles [list $item]
	} else {
	    lset piles $p end+1 $item
	}
    }
    # Merge the piles; no suitable builtin, alas
    set indices [lrepeat [llength $piles] 0]
    set result {}
    while 1 {
	set j 0
	foreach pile $piles i $indices {
	    set val [lindex $pile $i]
	    if {$i < [llength $pile] && (![info exist min] || $min > $val)} {
		set k $j
		set next [incr i]
		set min $val
	    }
	    incr j
	}
	if {![info exist min]} break
	lappend result $min
	unset min
	lset indices $k $next
    }
    return $result
}
