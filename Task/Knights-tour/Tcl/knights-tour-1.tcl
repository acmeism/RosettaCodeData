package require Tcl 8.6;    # For object support, which makes coding simpler

oo::class create KnightsTour {
    variable width height visited

    constructor {{w 8} {h 8}} {
	set width $w
	set height $h
	set visited {}
    }

    method ValidMoves {square} {
	lassign $square c r
	set moves {}
	foreach {dx dy} {-1 -2  -2 -1  -2 1  -1 2  1 2  2 1  2 -1  1 -2} {
	    set col [expr {($c % $width) + $dx}]
	    set row [expr {($r % $height) + $dy}]
	    if {$row >= 0 && $row < $height && $col >=0 && $col < $width} {
		lappend moves [list $col $row]
	    }
	}
	return $moves
    }

    method CheckSquare {square} {
	set moves 0
	foreach site [my ValidMoves $square] {
	    if {$site ni $visited} {
		incr moves
	    }
	}
	return $moves
    }

    method Next {square} {
	set minimum 9
	set nextSquare {-1 -1}
	foreach site [my ValidMoves $square] {
	    if {$site ni $visited} {
		set count [my CheckSquare $site]
		if {$count < $minimum} {
		    set minimum $count
		    set nextSquare $site
		} elseif {$count == $minimum} {
		    set nextSquare [my Edgemost $nextSquare $site]
		}
	    }
	}
	return $nextSquare
    }

    method Edgemost {a b} {
	lassign $a ca ra
	lassign $b cb rb
	# Calculate distances to edge
	set da [expr {min($ca, $width - 1 - $ca, $ra, $height - 1 - $ra)}]
	set db [expr {min($cb, $width - 1 - $cb, $rb, $height - 1 - $rb)}]
	if {$da < $db} {return $a} else {return $b}
    }

    method FormatSquare {square} {
	lassign $square c r
	format %c%d [expr {97 + $c}] [expr {1 + $r}]
    }

    method constructFrom {initial} {
	while 1 {
	    set visited [list $initial]
	    set square $initial
	    while 1 {
		set square [my Next $square]
		if {$square eq {-1 -1}} {
		    break
		}
		lappend visited $square
	    }
	    if {[llength $visited] == $height*$width} {
		return
	    }
	    puts stderr "rejecting path of length [llength $visited]..."
	}
    }

    method constructRandom {} {
	my constructFrom [list \
		[expr {int(rand()*$width)}] [expr {int(rand()*$height)}]]
    }

    method print {} {
	set s "      "
	foreach square $visited {
	    puts -nonewline "$s[my FormatSquare $square]"
	    if {[incr i]%12} {
		set s " -> "
	    } else {
		set s "\n   -> "
	    }
	}
	puts ""
    }

    method isClosed {} {
	set a [lindex $visited 0]
	set b [lindex $visited end]
	expr {$a in [my ValidMoves $b]}
    }
}
