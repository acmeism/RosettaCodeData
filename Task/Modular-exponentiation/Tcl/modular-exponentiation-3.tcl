package require Tcl 8.5
proc modexp {a b n} {
    for {set c 1} {$b} {set a [expr {$a*$a % $n}]} {
	if {$b & 1} {
	    set c [expr {$c*$a % $n}]
	}
	set b [expr {$b >> 1}]
    }
    return $c
}
