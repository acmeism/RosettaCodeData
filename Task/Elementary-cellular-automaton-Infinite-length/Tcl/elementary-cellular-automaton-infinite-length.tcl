package require Tcl 8.6

oo::class create InfiniteElementaryAutomaton {
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
    method evolve {left state right} {
	set state [list $left {*}$state $right]
	set len [llength $state]
	for {set i -1;set j 0;set k 1} {$j < $len} {incr i;incr j;incr k} {
	    set a [expr {$i<0 ? $left : [lindex $state $i]}]
	    set b [lindex $state $j]
	    set c [expr {$k==$len ? $right : [lindex $state $k]}]
	    lappend result [dict get $rules $a$b$c]
	}
	return $result
    }

    method evolveEnd {endState} {
	return [dict get $rules $endState$endState$endState]
    }

    # Simple driver method; omit the initial state to get a centred dot
    method run {steps {initialState "010"}} {
	set cap [string repeat "\u2026" $steps]
	set s [split [string map ". 0 # 1" $initialState] ""]
	set left [lindex $s 0]
	set right [lindex $s end]
	set s [lrange $s 1 end-1]
	for {set i 0} {$i < $steps} {incr i} {
	    puts $cap[string map "0 . 1 #" $left[join $s ""]$right]$cap
	    set s [my evolve $left $s $right]
	    set left [my evolveEnd $left]
	    set right [my evolveEnd $right]
	    set cap [string range $cap 1 end]
	}
	puts $cap[string map "0 . 1 #" $left[join $s ""]$right]$cap
    }
}

foreach num {90 30} {
    puts "Rule ${num}:"
    set rule [InfiniteElementaryAutomaton new $num]
    $rule run 25
    $rule destroy
}
