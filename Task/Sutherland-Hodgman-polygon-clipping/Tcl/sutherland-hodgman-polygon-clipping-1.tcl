# Find intersection of an arbitrary polygon with a convex one.
package require Tcl 8.6

#	Does the path (x0,y0)->(x1,y1)->(x2,y2) turn clockwise
#	or counterclockwise?
proc cw {x0 y0 x1 y1 x2 y2} {
    set dx1 [expr {$x1 - $x0}]; set dy1 [expr {$y1 - $y0}]
    set dx2 [expr {$x2 - $x0}]; set dy2 [expr {$y2 - $y0}]
    # (0,0,$dx1*$dy2 - $dx2*$dy1) is the crossproduct of
    # ($x1-$x0,$y1-$y0,0) and ($x2-$x0,$y2-$y0,0).
    # Its z-component is positive if the turn
    # is clockwise, negative if the turn is counterclockwise.
    set pr1 [expr {$dx1 * $dy2}]
    set pr2 [expr {$dx2 * $dy1}]
    if {$pr1 > $pr2} {
	# Clockwise
	return 1
    } elseif {$pr1 < $pr2} {
	# Counter-clockwise
	return -1
    } elseif {$dx1*$dx2 < 0 || $dy1*$dy2 < 0} {
	# point 0 is the middle point
	return 0
    } elseif {($dx1*$dx1 + $dy1*$dy1) < ($dx2*$dx2 + $dy2+$dy2)} {
	# point 1 is the middle point
	return 0
    } else {
	# point 2 lies on the segment joining points 0 and 1
	return 1
    }
}

#	Calculate the point of intersection of two lines
#	containing the line segments (x1,y1)-(x2,y2) and (x3,y3)-(x4,y4)
proc intersect {x1 y1 x2 y2 x3 y3 x4 y4} {
    set d [expr {($y4 - $y3) * ($x2 - $x1) - ($x4 - $x3) * ($y2 - $y1)}]
    set na [expr {($x4 - $x3) * ($y1 - $y3) - ($y4 - $y3) * ($x1 - $x3)}]
    if {$d == 0} {
	return {}
    }
    set r [list \
	    [expr {$x1 + $na * ($x2 - $x1) / $d}] \
	    [expr {$y1 + $na * ($y2 - $y1) / $d}]]
    return $r
}

#	Coroutine that yields the elements of a list in pairs
proc pairs {list} {
    yield [info coroutine]
    foreach {x y} $list {
	yield [list $x $y]
    }
    return {}
}

#	Coroutine to clip one segment of a polygon against a line.
proc clipsegment {inside0 cx0 cy0 cx1 cy1 sx0 sy0 sx1 sy1} {
    set inside1 [expr {[cw $cx0 $cy0 $cx1 $cy1 $sx1 $sy1] > 0}]
    if {$inside1} {
	if {!$inside0} {
	    set int [intersect $cx0 $cy0 $cx1 $cy1 \
		    $sx0 $sy0 $sx1 $sy1]
	    if {[llength $int] >= 0} {
		yield $int
	    }
	}
	yield [list $sx1 $sy1]
    } else {
	if {$inside0} {
	    set int [intersect $cx0 $cy0 $cx1 $cy1 \
		    $sx0 $sy0 $sx1 $sy1]
	    if {[llength $int] >= 0} {
		yield $int
	    }
	}
    }
    return $inside1
}

#	Coroutine to perform one step of Sutherland-Hodgman polygon clipping
proc clipstep {source cx0 cy0 cx1 cy1} {
    yield [info coroutine]
    set pt0 [{*}$source]
    if {[llength $pt0] == 0} {
	return
    }
    lassign $pt0 sx0 sy0
    set inside0 [expr {[cw $cx0 $cy0 $cx1 $cy1 $sx0 $sy0] > 0}]
    set finished 0
    while {!$finished} {
	set thispt [{*}$source]
	if {[llength $thispt] == 0} {
	    set thispt $pt0
	    set finished 1
	}
	lassign $thispt sx1 sy1
	set inside0 [clipsegment $inside0 \
		$cx0 $cy0 $cx1 $cy1 $sx0 $sy0 $sx1 $sy1]
	set sx0 $sx1
	set sy0 $sy1
    }
    return {}
}

#	Perform Sutherland-Hodgman polygon clipping
proc clippoly {cpoly spoly} {
    variable clipindx
    set source [coroutine clipper[incr clipindx] pairs $spoly]
    set cx0 [lindex $cpoly end-1]
    set cy0 [lindex $cpoly end]
    foreach {cx1 cy1} $cpoly {
	set source [coroutine clipper[incr clipindx] \
		clipstep $source $cx0 $cy0 $cx1 $cy1]
	set cx0 $cx1; set cy0 $cy1
    }
    set result {}
    while {[llength [set pt [{*}$source]]] > 0} {
	lappend result {*}$pt
    }
    return $result
}
