package require Tcl 8.6

proc r2cf {n1 {n2 1}} {
    # Convert a decimal fraction (e.g., 1.23) into a form we can handle
    if {$n1 != int($n1) && [regexp {\.(\d+)} $n1 -> suffix]} {
	set pow [string length $suffix]
	set n1 [expr {int($n1 * 10**$pow)}]
	set n2 [expr {$n2 * 10**$pow}]
    }
    # Construct the continued fraction as a coroutine that yields the digits in sequence
    coroutine cf\#[incr ::cfcounter] apply {{n1 n2} {
	yield [info coroutine]
	while {$n2 > 0} {
	    yield [expr {$n1 / $n2}]
	    set n2 [expr {$n1 % [set n1 $n2]}]
	}
	return -code break
    }} $n1 $n2
}
