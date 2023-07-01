package require Tcl 8.5
namespace eval 1D {
    namespace ensemble create;   # Will be same name as namespace
    namespace export convolve deconvolve
    # Access core language math utility commands
    namespace path {::tcl::mathfunc ::tcl::mathop}

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

    # How to apply a 1D convolution of two "functions"
    proc convolve {f h} {
	set g [lrepeat [+ [llength $f] [llength $h] -1] 0]
	set fi -1
	foreach fv $f {
	    incr fi
	    set hi -1
	    foreach hv $h {
		set gi [+ $fi [incr hi]]
		lset g $gi [+ [lindex $g $gi] [* $fv $hv]]
	    }
	}
	return $g
    }

    # How to apply a 1D deconvolution of two "functions"
    proc deconvolve {g f} {
	# Compute the length of the result vector
	set hlen [- [llength $g] [llength $f] -1]

	# Build a matrix of equations to solve
	set matrix {}
	set i -1
	foreach gv $g {
	    lappend matrix [list {*}[lrepeat $hlen 0] $gv]
	    set j [incr i]
	    foreach fv $f {
		if {$j < 0} {
		    break
		} elseif {$j < $hlen} {
		    lset matrix $i $j $fv
		}
		incr j -1
	    }
	}

	# Convert to RREF, solving the system of simultaneous equations
	set reduced [toRREF $matrix]

	# Extract the deconvolution from the last column of the reduced matrix
	for {set i 0} {$i<$hlen} {incr i} {
	    lappend result [lindex $reduced $i end]
	}
	return $result
    }
}
