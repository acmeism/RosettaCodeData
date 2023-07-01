proc findCircles {p1 p2 r} {
    lassign $p1 x1 y1
    lassign $p2 x2 y2
    # Special case: coincident & zero size
    if {$x1 == $x2 && $y1 == $y2 && $r == 0.0} {
	return [list [list $x1 $y1 0.0]]
    }
    if {$r <= 0.0} {
	error "radius must be positive for sane results"
    }
    if {$x1 == $x2 && $y1 == $y2} {
	error "no sane solution: points are coincident"
    }

    # Calculate distance apart and separation vector
    set dx [expr {$x2 - $x1}]
    set dy [expr {$y2 - $y1}]
    set q [expr {hypot($dx, $dy)}]
    if {$q > 2*$r} {
	error "no solution: points are further apart than required diameter"
    }

    # Calculate midpoint
    set x3 [expr {($x1+$x2)/2.0}]
    set y3 [expr {($y1+$y2)/2.0}]
    # Fractional distance along the mirror line
    set f [expr {($r**2 - ($q/2.0)**2)**0.5 / $q}]
    # The two answers
    set c1 [list [expr {$x3 - $f*$dy}] [expr {$y3 + $f*$dx}] $r]
    set c2 [list [expr {$x3 + $f*$dy}] [expr {$y3 - $f*$dx}] $r]
    return [list $c1 $c2]
}
