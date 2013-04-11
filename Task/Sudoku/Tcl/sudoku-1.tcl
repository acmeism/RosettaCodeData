package require Tcl 8.6
oo::class create Sudoku {
    variable idata

    method clear {} {
	for {set y 0} {$y < 9} {incr y} {
	    for {set x 0} {$x < 9} {incr x} {
		my set $x $y {}
	    }
	}
    }
    method load {data} {
	set error "data must be a 9-element list, each element also being a\
		list of 9 numbers from 1 to 9 or blank or an @ symbol."
	if {[llength $data] != 9} {
	    error $error
	}
	for {set y 0} {$y<9} {incr y} {
	    set row [lindex $data $y]
	    if {[llength $row] != 9} {
		error $error
	    }
	    for {set x 0} {$x<9} {incr x} {
		set d [lindex $row $x]
		if {![regexp {^[@1-9]?$} $d]} {
		    error $d-$error
		}
		if {$d eq "@"} {set d ""}
		my set $x $y $d
	    }
	}
    }
    method dump {} {
	set rows {}
	for {set y 0} {$y < 9} {incr y} {
	    lappend rows [my getRow 0 $y]
	}
	return $rows
    }

    method Log msg {
	# Chance to print message
    }

    method set {x y value} {
	if {[catch {set value [format %d $value]}]} {set value 0}
	if {$value<1 || $value>9} {
	    set idata(sq$x$y) {}
	} else {
	    set idata(sq$x$y) $value
	}
    }
    method get {x y} {
	if {![info exists idata(sq$x$y)]} {
	    return {}
	}
	return $idata(sq$x$y)
    }

    method getRow {x y} {
	set row {}
	for {set x 0} {$x<9} {incr x} {
	    lappend row [my get $x $y]
	}
	return $row
    }
    method getCol {x y} {
	set col {}
	for {set y 0} {$y<9} {incr y} {
	    lappend col [my get $x $y]
	}
	return $col
    }
    method getRegion {x y} {
	set xR [expr {($x/3)*3}]
	set yR [expr {($y/3)*3}]
	set regn {}
	for {set x $xR} {$x < $xR+3} {incr x} {
	    for {set y $yR} {$y < $yR+3} {incr y} {
		lappend regn [my get $x $y]
	    }
	}
	return $regn
    }
}

# SudokuSolver inherits from Sudoku, and adds the ability to filter
# possibilities for a square by looking at all the squares in the row, column,
# and region that the square is a part of. The method 'solve' contains a list
# of rule-objects to use, and iterates over each square on the board, applying
# each rule sequentially until the square is allocated.

oo::class create SudokuSolver {
    superclass Sudoku
    method validchoices {x y} {
	if {[my get $x $y] ne {}} {
	    return [my get $x $y]
	}

	set row [my getRow $x $y]
	set col [my getCol $x $y]
	set regn [my getRegion $x $y]
	set eliminate [list {*}$row {*}$col {*}$regn]
	set eliminate [lsearch -all -inline -not $eliminate {}]
	set eliminate [lsort -unique $eliminate]

	set choices {}
	for {set c 1} {$c < 10} {incr c} {
	    if {$c ni $eliminate} {
		lappend choices $c
	    }
	}
	if {[llength $choices]==0} {
	    error "No choices left for square $x,$y"
	}
	return $choices
    }
    method completion {} {
	return [expr {
	    81-[llength [lsearch -all -inline [join [my dump]] {}]]
	}]
    }
    method solve {} {
	foreach ruleClass [info class subclass Rule] {
	    lappend rules [$ruleClass new]
	}

	while {1} {
	    set begin [my completion]
	    for {set y 0} {$y < 9} {incr y} {
		for {set x 0} {$x < 9} {incr x} {
		    if {[my get $x $y] eq ""} {
			foreach rule $rules {
			    set c [$rule solve [self] $x $y]
			    if {$c} {
				my set $x $y $c
				my Log "[info object class $rule] solved [self] at $x,$y for $c"
				break
			    }
			}
		    }
		}
	    }
	    set end [my completion]
	    if {$end==81} {
		my Log "Finished solving!"
		break
	    } elseif {$begin==$end} {
		my Log "A round finished without solving any squares, giving up."
		break
	    }
	}
	foreach rule $rules {
	    $rule destroy
	}
    }
}

# Rule is the template for the rules used in Solver. The other rule-objects
# apply their logic to the values passed in and return either '0' or a number
# to allocate to the requested square.
oo::class create Rule {
    method solve {hSudoku x y} {
	if {![info object isa typeof $hSudoku SudokuSolver]} {
	    error "hSudoku must be an instance of class SudokuSolver."
	}

	tailcall my Solve $hSudoku $x $y [$hSudoku validchoices $x $y]
    }
}

# Get all the allocated numbers for each square in the the row, column, and
# region containing $x,$y. If there is only one unallocated number among all
# three groups, it must be allocated at $x,$y
oo::class create RuleOnlyChoice {
    superclass Rule
    method Solve {hSudoku x y choices} {
	if {[llength $choices]==1} {
	    return $choices
	} else {
	    return 0
	}
    }
}

# Test each column to determine if $choice is an invalid choice for all other
# columns in row $X. If it is, it must only go in square $x,$y.
oo::class create RuleColumnChoice {
    superclass Rule
    method Solve {hSudoku x y choices} {
	foreach choice $choices {
	    set failed 0
	    for {set x2 0} {$x2<9} {incr x2} {
		if {$x2 != $x && $choice in [$hSudoku validchoices $x2 $y]} {
		    set failed 1
		    break
		}
	    }
	    if {!$failed} {return $choice}
	}
	return 0
    }
}

# Test each row to determine if $choice is an invalid choice for all other
# rows in column $y. If it is, it must only go in square $x,$y.
oo::class create RuleRowChoice {
    superclass Rule
    method Solve {hSudoku x y choices} {
	foreach choice $choices {
	    set failed 0
	    for {set y2 0} {$y2<9} {incr y2} {
		if {$y2 != $y && $choice in [$hSudoku validchoices $x $y2]} {
		    set failed 1
		    break
		}
	    }
	    if {!$failed} {return $choice}
	}
	return 0
    }
}

# Test each square in the region occupied by $x,$y to determine if $choice is
# an invalid choice for all other squares in that region. If it is, it must
# only go in square $x,$y.
oo::class create RuleRegionChoice {
    superclass Rule
    method Solve {hSudoku x y choices} {
	foreach choice $choices {
	    set failed 0
	    set regnX [expr {($x/3)*3}]
	    set regnY [expr {($y/3)*3}]
	    for {set y2 $regnY} {$y2 < $regnY+3} {incr y2} {
		for {set x2 $regnX} {$x2 < $regnX+3} {incr x2} {
		    if {
			($x2!=$x || $y2!=$y)
			&& $choice in [$hSudoku validchoices $x2 $y2]
		    } then {
			set failed 1
			break
		    }
		}
	    }
	    if {!$failed} {return $choice}
	}
	return 0
    }
}
