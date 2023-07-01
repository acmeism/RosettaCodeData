package require struct::matrix
package require math::complexnumbers

proc complexMatrix.equal {m1 m2 {epsilon 1e-14}} {
    if {[$m1 rows] != [$m2 rows] || [$m1 columns] != [$m2 columns]} {
	return 0
    }
    # Compute the magnitude of the difference between two complex numbers
    set ceq [list apply {{epsilon a b} {
	expr {[mod [- $a $b]] < $epsilon}
    } ::math::complexnumbers} $epsilon]
    for {set i 0} {$i<[$m1 columns]} {incr i} {
	for {set j 0} {$j<[$m1 rows]} {incr j} {
	    if {![{*}$ceq [$m1 get cell $i $j] [$m2 get cell $i $j]]} {
		return 0
	    }
	}
    }
    return 1
}

proc complexMatrix.multiply {a b} {
    if {[$a columns] != [$b rows]} {
        error "incompatible sizes"
    }
    # Simplest to use a lambda in the complex NS
    set cpm {{sum a b} {
	+ $sum [* $a $b]
    } ::math::complexnumbers}
    set c0 [math::complexnumbers::complex 0.0 0.0];   # Complex zero
    set c [struct::matrix]
    $c add columns [$b columns]
    $c add rows [$a rows]
    for {set i 0} {$i < [$a rows]} {incr i} {
        for {set j 0} {$j < [$b columns]} {incr j} {
            set sum $c0
	    foreach rv [$a get row $i] cv [$b get column $j] {
		set sum [apply $cpm $sum $rv $cv]
            }
	    $c set cell $j $i $sum
        }
    }
    return $c
}

proc complexMatrix.conjugateTranspose {matrix} {
    set mat [struct::matrix]
    $mat = $matrix
    $mat transpose
    for {set c 0} {$c < [$mat columns]} {incr c} {
	for {set r 0} {$r < [$mat rows]} {incr r} {
	    set val [$mat get cell $c $r]
	    $mat set cell $c $r [math::complexnumbers::conj $val]
	}
    }
    return $mat
}
