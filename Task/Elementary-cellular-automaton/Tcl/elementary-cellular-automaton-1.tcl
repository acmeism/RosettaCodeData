package require Tcl 8.6

oo::class create ElementaryAutomaton {
    variable rules
    # Decode the rule number to get a collection of state mapping rules.
    # In effect, "compiles" the rule number
    constructor {ruleNumber} {
	set ins {111 110 101 100 011 010 001 000}
	set bits [split [string range [format %08b $ruleNumber] end-7 end] ""]
	foreach input {111 110 101 100 011 010 001 000} state $bits {
	    dict set rules $input $state
	}
    }

    # Apply the rule to an automaton state to get a new automaton state.
    # We wrap the edges; the state space is circular.
    method evolve {state} {
	set len [llength $state]
	for {set i 0} {$i < $len} {incr i} {
	    lappend result [dict get $rules [
		    lindex $state [expr {($i-1)%$len}]][
		    lindex $state $i][
		    lindex $state [expr {($i+1)%$len}]]]
	}
	return $result
    }

    # Simple driver method; omit the initial state to get a centred dot
    method run {steps {initialState ""}} {
	if {[llength [info level 0]] < 4} {
	    set initialState "[string repeat . $steps]1[string repeat . $steps]"
	}
	set s [split [string map ". 0 # 1" $initialState] ""]
	for {set i 0} {$i < $steps} {incr i} {
	    puts [string map "0 . 1 #" [join $s ""]]
	    set s [my evolve $s]
	}
	puts [string map "0 . 1 #" [join $s ""]]
    }
}
