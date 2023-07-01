package require Tcl 8.5
namespace eval matrix {
    namespace path {::tcl::mathfunc ::tcl::mathop}

    # Construct an identity matrix of the given size
    proc identity {order} {
	set m [lrepeat $order [lrepeat $order 0]]
	for {set i 0} {$i < $order} {incr i} {
	    lset m $i $i 1
	}
	return $m
    }

    # Produce the pivot matrix for a given matrix
    proc pivotize {matrix} {
	set n [llength $matrix]
	set p [identity $n]
	for {set j 0} {$j < $n} {incr j} {
	    set max [lindex $matrix $j $j]
	    set row $j
	    for {set i $j} {$i < $n} {incr i} {
		if {[lindex $matrix $i $j] > $max} {
		    set max [lindex $matrix $i $j]
		    set row $i
		}
	    }
	    if {$j != $row} {
		# Row swap inlined; too trivial to have separate procedure
		set tmp [lindex $p $j]
		lset p $j [lindex $p $row]
		lset p $row $tmp
	    }
	}
	return $p
    }

    # Decompose a square matrix A by PA=LU and return L, U and P
    proc luDecompose {A} {
	set n [llength $A]
	set L [lrepeat $n [lrepeat $n 0]]
	set U $L
	set P [pivotize $A]
	set A [multiply $P $A]

	for {set j 0} {$j < $n} {incr j} {
	    lset L $j $j 1
	    for {set i 0} {$i <= $j} {incr i} {
		lset U $i $j [- [lindex $A $i $j] [SumMul $L $U $i $j $i]]
	    }
	    for {set i $j} {$i < $n} {incr i} {
		set sum [SumMul $L $U $i $j $j]
		lset L $i $j [/ [- [lindex $A $i $j] $sum] [lindex $U $j $j]]
	    }
	}

	return [list $L $U $P]
    }

    # Helper that makes inner loop nicer; multiplies column and row,
    # possibly partially...
    proc SumMul {A B i j kmax} {
	set s 0.0
	for {set k 0} {$k < $kmax} {incr k} {
	    set s [+ $s [* [lindex $A $i $k] [lindex $B $k $j]]]
	}
	return $s
    }
}
