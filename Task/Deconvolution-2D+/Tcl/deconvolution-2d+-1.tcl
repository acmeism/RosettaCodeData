package require Tcl 8.5
namespace path {::tcl::mathfunc ::tcl::mathop}

# Utility to extract the number of dimensions of a matrix
proc rank m {
    for {set rank 0} {[llength $m] > 1} {incr rank} {
	set m [lindex $m 0]
    }
    return $rank
}

# Utility to get the size of a matrix, as a list of lengths
proc size m {
    set r [rank $m]
    set index {}
    set size {}
    for {set i 0} {$i<$r} {incr i} {
	lappend size [llength [lindex $m $index]]
	lappend index 0
    }
    return $size
}

# Utility that iterates over the space of coordinates within a matrix.
#
# Arguments:
#   var   The name of the variable (in the caller's context) to set to each
#         coordinate.
#   size  The size of matrix whose coordinates are to be iterated over.
#   body  The script to evaluate (in the caller's context) for each coordinate,
#         with the variable named by 'var' set to the coordinate for the particular
#         iteration.
proc loopcoords {var size body} {
    upvar 1 $var v
    set count [* {*}$size]
    for {set i 0} {$i < $count} {incr i} {
	set coords {}
	set j $i
	for {set s $size} {[llength $s]} {set s [lrange $s 0 end-1]} {
	    set dimension [lindex $s end]
	    lappend coords [expr {$j % $dimension}]
	    set j [expr {$j / $dimension}]
	}
	set v [lreverse $coords]
	uplevel 1 $body
    }
}

# Assembles a row, which is one of the simultaneous equations that needs
# to be solved by reducing the whole set to reduced row echelon form. Note
# that each row describes the equation for a single cell of the 'g' function.
#
# Arguments:
#   g	The "result" matrix of the convolution being undone.
#   h	The known "input" matrix of the convolution being undone.
#   gs	The size descriptor of 'g', passed as argument for efficiency.
#   gc	The coordinate in 'g' that we are generating the equation for.
#   fs	The size descriptor of 'f', passed as argument for efficiency.
#   hs	The size descriptor of 'h' (the unknown "input" matrix), passed
#	as argument for efficiency.
proc row {g f gs gc fs hs} {
    loopcoords hc $hs {
	set fc {}
	set ok 1
	foreach a $gc b $fs c $hc {
	    set d [expr {$a - $c}]
	    if {$d < 0 || $d >= $b} {
		set ok 0
		break
	    }
	    lappend fc $d
	}
	if {$ok} {
	    lappend row [lindex $f $fc]
	} else {
	    lappend row 0
	}
    }
    return [lappend row [lindex $g $gc]]
}

# Utility for converting a matrix to Reduced Row Echelon Form
# From http://rosettacode.org/wiki/Reduced_row_echelon_form#Tcl
proc toRREF {m} {
    set lead 0
    set rows [llength $m]
    set cols [llength [lindex $m 0]]
    for {set r 0} {$r < $rows} {incr r} {
	if {$cols <= $lead} {
	    break
	}
	set i $r
	while {[lindex $m $i $lead] == 0} {
	    incr i
	    if {$rows == $i} {
		set i $r
		incr lead
		if {$cols == $lead} {
		    # Tcl can't break out of nested loops
		    return $m
		}
	    }
	}
	# swap rows i and r
	foreach j [list $i $r] row [list [lindex $m $r] [lindex $m $i]] {
	    lset m $j $row
	}
	# divide row r by m(r,lead)
	set val [lindex $m $r $lead]
	for {set j 0} {$j < $cols} {incr j} {
	    lset m $r $j [/ [double [lindex $m $r $j]] $val]
	}

	for {set i 0} {$i < $rows} {incr i} {
	    if {$i != $r} {
		# subtract m(i,lead) multiplied by row r from row i
		set val [lindex $m $i $lead]
		for {set j 0} {$j < $cols} {incr j} {
		    lset m $i $j \
			[- [lindex $m $i $j] [* $val [lindex $m $r $j]]]
		}
	    }
	}
	incr lead
    }
    return $m
}

# Deconvolve a pair of matrixes. Solves for 'h' such that 'g = f convolve h'.
#
# Arguments:
#   g     The matrix of data to be deconvolved.
#   f     The matrix describing the convolution to be removed.
#   type  Optional description of the type of data expected. Defaults to 32-bit
#         integer data; use 'double' for floating-point data.
proc deconvolve {g f {type int}} {
    # Compute the sizes of the various matrixes involved.
    set gsize [size $g]
    set fsize [size $f]
    foreach gs $gsize fs $fsize {
	lappend hsize [expr {$gs - $fs + 1}]
    }

    # Prepare the set of simultaneous equations to solve
    set toSolve {}
    loopcoords coords $gsize {
	lappend toSolve [row $g $f $gsize $coords $fsize $hsize]
    }

    # Solve the equations
    set solved [toRREF $toSolve]

    # Make a dummy result matrix of the right size
    set h 0
    foreach hs [lreverse $hsize] {set h [lrepeat $hs $h]}

    # Fill the results from the equations into the result matrix
    set idx 0
    loopcoords coords $hsize {
	lset h $coords [$type [lindex $solved $idx end]]
	incr idx
    }

    return $h
}
