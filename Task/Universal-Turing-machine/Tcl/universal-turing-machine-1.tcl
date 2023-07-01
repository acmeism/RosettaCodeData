proc turing {states initial terminating symbols blank tape rules {doTrace 1}} {
    set state $initial
    set idx 0
    set tape [split $tape ""]
    if {[llength $tape] == 0} {
	set tape [list $blank]
    }
    foreach rule $rules {
	lassign $rule state0 sym0 sym1 move state1
	set R($state0,$sym0) [list $sym1 $move $state1]
    }
    while {$state ni $terminating} {
	set sym [lindex $tape $idx]
	lassign $R($state,$sym) sym1 move state1
	if {$doTrace} {
	    ### Print the state, great for debugging
	    puts "[join $tape ""]\t$state->$state1"
	    puts "[string repeat { } $idx]^"
	}
	lset tape $idx $sym1
	switch $move {
	    left {
		if {[incr idx -1] < 0} {
		    set idx 0
		    set tape [concat [list $blank] $tape]
		}
	    }
	    right {
		if {[incr idx] == [llength $tape]} {
		    lappend tape $blank
		}
	    }
	}
	set state $state1
    }
    return [join $tape ""]
}
