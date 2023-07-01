package require Tcl 8.6

oo::class create Flip {
    variable board target s
    constructor {size} {
	set s $size
	set target [my RandomConfiguration]
	set board $target
	while {$board eq $target} {
	    for {set i 0} {$i < $s} {incr i} {
		if {rand()<.5} {
		    my SwapRow $i
		}
		if {rand()<.5} {
		    my SwapColumn $i
		}
	    }
	}
    }

    method RandomConfiguration {{p 0.5}} {
	for {set row 0} {$row < $s} {incr row} {
	    set r {}
	    for {set col 0} {$col < $s} {incr col} {
		lappend r [expr {rand() < $p}]
	    }
	    lappend result $r
	}
	return $result
    }

    method SwapRow {rowId} {
	for {set i 0} {$i < $s} {incr i} {
	    lset board $rowId $i [expr {![lindex $board $rowId $i]}]
	}
    }
    method SwapColumn {columnId} {
	for {set i 0} {$i < $s} {incr i} {
	    lset board $i $columnId [expr {![lindex $board $i $columnId]}]
	}
    }

    method Render {configuration {prefixes {}}} {
	join [lmap r $configuration p $prefixes {
	    format %s%s $p [join [lmap c $r {string index ".X" $c}] ""]
	}] "\n"
    }
    method GetInput {prompt} {
	puts -nonewline "${prompt}: "
	flush stdout
	gets stdin
    }

    method play {} {
	set p0 {}
	set p {}
	set top [format "%*s " [string length $s] ""]
	for {set i 1;set j 97} {$i<=$s} {incr i;incr j} {
	    append top [format %c $j]
	    lappend p [format "%*d " [string length $s] $i]
	    lappend p0 [format "%*s " [string length $s] ""]
	}

	set moves 0
	puts "You are trying to get to:\n[my Render $target $p0]\n"
	while true {
	    puts "Current configuration (#$moves):\n$top\n[my Render $board $p]"

	    # Test for if we've won
	    if {$board eq $target} break

	    # Ask the user for a move
	    set i [my GetInput "Pick a column (letter) or row (number) to flip"]

	    # Parse the move and apply it
	    if {[string is lower -strict $i] && [set c [expr {[scan $i "%c"] - 97}]]<$s} {
		my SwapColumn $c
		incr moves
	    } elseif {[string is integer -strict $i] && $i>0 && $i<=$s} {
		my SwapRow [expr {$i - 1}]
		incr moves
	    } else {
		puts "Error: bad selection"
	    }
	    puts ""
	}
	puts "\nYou win! (You took $moves moves.)"
    }
}

Flip create flip 3
flip play
