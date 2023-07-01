package require Tcl 8.5
package require math::constants
math::constants::constants pi
proc tcl::mathfunc::randf m {expr {$m * rand()}}

proc genXY {count radius} {
    global pi
    for {set i 0} {$i < $count} {incr i} {
	set ang [expr {randf(2 * $pi)}]
	set r [expr {randf($radius)}]
	lappend pt [list [expr {$r*cos($ang)}] [expr {$r*sin($ang)}] -1]
    }
    return $pt
}
proc dist2 {a b} {
    lassign $a ax ay
    lassign $b bx by
    return [expr {($ax-$bx)**2 + ($ay-$by)**2}]
}

proc nearest {pt cent {d2var ""}} {
    set minD 1e30
    set minI [lindex $pt 2]
    set i -1
    foreach c $cent {
	incr i
	set d [dist2 $c $pt]
	if {$minD > $d} {
	    set minD $d
	    set minI $i
	}
    }
    if {$d2var ne ""} {
	upvar 1 $d2var d2
	set d2 $minD
    }
    return $minI
}

proc kpp {ptsVar centVar numClusters} {
    upvar 1 $ptsVar pts $centVar cent
    set idx [expr {int([llength $pts] * rand())}]
    set cent [list [lindex $pts $idx]]
    for {set nCent 1} {$nCent < $numClusters} {incr nCent} {
	set sum 0
	set d {}
	foreach p $pts {
	    nearest $p $cent dd
	    set sum [expr {$sum + $dd}]
	    lappend d $dd
	}
	set sum [expr {randf($sum)}]
	foreach p $pts dj $d {
	    set sum [expr {$sum - $dj}]
	    if {$sum <= 0} {
		lappend cent $p
		break
	    }
	}
    }
    set i -1
    foreach p $pts {
	lset pts [incr i] 2 [nearest $p $cent]
    }
}

proc lloyd {ptsVar numClusters} {
    upvar 1 $ptsVar pts
    kpp pts cent $numClusters
    while 1 {
	# Find centroids for round
	set groupCounts [lrepeat [llength $cent] 0]
	foreach p $pts {
	    lassign $p cx cy group
	    lset groupCounts $group [expr {[lindex $groupCounts $group] + 1}]
	    lset cent $group 0 [expr {[lindex $cent $group 0] + $cx}]
	    lset cent $group 1 [expr {[lindex $cent $group 1] + $cy}]
	}
	set i -1
	foreach groupn $groupCounts {
	    incr i
	    lset cent $i 0 [expr {[lindex $cent $i 0] / $groupn}]
	    lset cent $i 1 [expr {[lindex $cent $i 1] / $groupn}]
	}

	set changed 0
	set i -1
	foreach p $pts {
	    incr i
	    set minI [nearest $p $cent]
	    if {$minI != [lindex $p 2]} {
		incr changed
		lset pts $i 2 $minI
	    }
	}
	if {$changed < ([llength $pts] >> 10)} break
    }
    set i -1
    foreach c $cent {
	lset cent [incr i] 2 $i
    }
    return $cent
}
