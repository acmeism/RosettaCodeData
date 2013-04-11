# Code adapted from Matrix_multiplication and Matrix_transposition tasks
namespace eval matrix {
    # Get the size of a matrix; assumes that all rows are the same length, which
    # is a basic well-formed-ness condition...
    proc size {m} {
	set rows [llength $m]
	set cols [llength [lindex $m 0]]
	return [list $rows $cols]
    }

    # Matrix multiplication implementation
    proc multiply {a b} {
	lassign [size $a] a_rows a_cols
	lassign [size $b] b_rows b_cols
	if {$a_cols != $b_rows} {
	    error "incompatible sizes: a($a_rows, $a_cols), b($b_rows, $b_cols)"
	}
	set temp [lrepeat $a_rows [lrepeat $b_cols 0]]
	for {set i 0} {$i < $a_rows} {incr i} {
	    for {set j 0} {$j < $b_cols} {incr j} {
		lset temp $i $j [SumMul $a $b $i $j $a_cols]
	    }
	}
	return $temp
    }

    # Pretty printer for matrices
    proc print {matrix {fmt "%g"}} {
	set max [Widest $matrix $fmt]
	lassign [size $matrix] rows cols
	foreach row $matrix {
	    foreach val $row width $max {
		puts -nonewline [format "%*s " $width [format $fmt $val]]
	    }
	    puts ""
	}
    }
    proc Widest {m fmt} {
	lassign [size $m] rows cols
	set max [lrepeat $cols 0]
	foreach row $m {
	    for {set j 0} {$j < $cols} {incr j} {
		set s [format $fmt [lindex $row $j]]
		lset max $j [max [lindex $max $j] [string length $s]]
	    }
	}
	return $max
    }
}
