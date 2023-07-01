set C 7
set zero {x inf y inf}
proc tcl::mathfunc::cuberoot n {
    # General power operator doesn't like negative, but its defined for root3
    expr {$n>=0 ? $n**(1./3) : -((-$n)**(1./3))}
}
proc iszero p {
    dict with p {}
    return [expr {$x > 1e20 || $x<-1e20}]
}
proc negate p {
    dict set p y [expr {-[dict get $p y]}]
}
proc double p {
    if {[iszero $p]} {return $p}
    dict with p {}
    set L [expr {(3.0 * $x**2) / (2.0 * $y)}]
    set rx [expr {$L**2 - 2.0 * $x}]
    set ry [expr {$L * ($x - $rx) - $y}]
    return [dict create x $rx y $ry]
}
proc add {p q} {
    if {[dict get $p x]==[dict get $q x] && [dict get $p y]==[dict get $q y]} {
	return [double $p]
    }
    if {[iszero $p]} {return $q}
    if {[iszero $q]} {return $p}

    dict with p {}
    set L [expr {([dict get $q y]-$y) / ([dict get $q x]-$x)}]
    dict set r x [expr {$L**2 - $x - [dict get $q x]}]
    dict set r y [expr {$L * ($x - [dict get $r x]) - $y}]
    return $r
}
proc multiply {p n} {
    set r $::zero
    for {set i 1} {$i <= $n} {incr i $i} {
	if {$i & int($n)} {
	    set r [add $r $p]
	}
	set p [double $p]
    }
    return $r
}
