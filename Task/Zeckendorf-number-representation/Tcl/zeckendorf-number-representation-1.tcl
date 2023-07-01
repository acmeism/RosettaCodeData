package require Tcl 8.5

# Generates the Fibonacci sequence (starting at 1) up to the largest item that
# is no larger than the target value. Could use tricks to precompute, but this
# is actually a pretty cheap linear operation.
proc fibseq target {
    set seq {}; set prev 1; set fib 1
    for {set n 1;set i 1} {$fib <= $target} {incr n} {
	for {} {$i < $n} {incr i} {
	    lassign [list $fib [incr fib $prev]] prev fib
	}
	if {$fib <= $target} {
	    lappend seq $fib
	}
    }
    return $seq
}

# Produce the given Zeckendorf number.
proc zeckendorf n {
    # Special case: only value that begins with 0
    if {$n == 0} {return 0}
    set zs {}
    foreach f [lreverse [fibseq $n]] {
	lappend zs [set z [expr {$f <= $n}]]
	if {$z} {incr n [expr {-$f}]}
    }
    return [join $zs ""]
}
