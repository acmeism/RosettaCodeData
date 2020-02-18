package require Tcl 8.5

proc partial_sum {func - start - stop} {
    for {set x $start; set sum 0} {$x <= $stop} {incr x} {
        set sum [expr {$sum + [apply $func $x]}]
    }
    return $sum
}

set S {x {expr {1.0 / $x**2}}}

partial_sum $S from 1 to 1000 ;# => 1.6439345666815615
