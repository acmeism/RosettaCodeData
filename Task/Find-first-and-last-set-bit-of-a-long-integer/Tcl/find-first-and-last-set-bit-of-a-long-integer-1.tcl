proc lwb {x} {
    if {$x == 0} {return -1}
    set n 0
    while {($x&1) == 0} {
	set x [expr {$x >> 1}]
	incr n
    }
    return $n
}
proc upb {x} {
    if {$x == 0} {return -1}
    if {$x < 0} {error "no well-defined max bit for negative numbers"}
    set n 0
    while {$x != 1} {
	set x [expr {$x >> 1}]
	incr n
    }
    return $n
}
