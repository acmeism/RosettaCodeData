package require Tcl 8.5
proc binom {n k} {
    # Compute the top half of the division; this is n!/(n-k)!
    set pTop 1
    for {set i $n} {$i > $n - $k} {incr i -1} {
	set pTop [expr {$pTop * $i}]
    }

    # Compute the bottom half of the division; this is k!
    set pBottom 1
    for {set i $k} {$i > 1} {incr i -1} {
	set pBottom [expr {$pBottom * $i}]
    }

    # Integer arithmetic divide is correct here; the factors always cancel out
    return [expr {$pTop / $pBottom}]
}
