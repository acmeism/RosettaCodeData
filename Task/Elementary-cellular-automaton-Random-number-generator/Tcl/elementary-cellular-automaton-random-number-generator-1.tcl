oo::class create RandomGenerator {
    superclass ElementaryAutomaton
    variable s
    constructor {stateLength} {
	next 30
	set s [split 1[string repeat 0 $stateLength] ""]
    }

    method rand {} {
	set bits {}
	while {[llength $bits] < 8} {
	    lappend bits [lindex $s 0]
	    set s [my evolve $s]
	}
	return [scan [join $bits ""] %b]
    }
}
