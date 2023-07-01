package require Tk

# OK, this stripped down version doesn't work for n<2…
proc fibword {n} {
    set fw {1 0}
    while {[llength $fw] < $n} {
	lappend fw [lindex $fw end][lindex $fw end-1]
    }
    return [lindex $fw end]
}
proc drawFW {canv fw {w {[$canv cget -width]}} {h {[$canv cget -height]}}} {
    set w [subst $w]
    set h [subst $h]

    # Generate the coordinate list using line segments of unit length
    set d 3; # Match the orientation in the sample paper
    set eo [set x [set y 0]]
    set coords [list $x $y]
    foreach c [split $fw ""] {
	switch $d {
	    0 {lappend coords [incr x] $y}
	    1 {lappend coords $x [incr y]}
	    2 {lappend coords [incr x -1] $y}
	    3 {lappend coords $x [incr y -1]}
	}
	if {$c == 0} {
	    set d [expr {($d + ($eo ? -1 : 1)) % 4}]
	}
	set eo [expr {!$eo}]
    }

    # Draw, and rescale to fit in canvas
    set id [$canv create line $coords]
    lassign [$canv bbox $id] x1 y1 x2 y2
    set sf [expr {min(($w-20.) / ($y2-$y1), ($h-20.) / ($x2-$x1))}]
    $canv move $id [expr {-$x1}] [expr {-$y1}]
    $canv scale $id 0 0 $sf $sf
    $canv move $id 10 10
    # Return the item ID to allow user reconfiguration
    return $id
}

pack [canvas .c -width 500 -height 500]
drawFW .c [fibword 23]
