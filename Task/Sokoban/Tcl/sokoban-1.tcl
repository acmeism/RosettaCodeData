package require Tcl 8.5

proc solveSokoban b {
    set cols [string length [lindex $b 0]]
    set dxes [list [expr {-$cols}] $cols -1 1]
    set i 0
    foreach c [split [join $b ""] ""] {
	switch $c {
	    " " {lappend bdc " "}
	    "#" {lappend bdc "#"}
	    "@" {lappend bdc " ";set startplayer $i }
	    "$" {lappend bdc " ";lappend startbox $i}
	    "." {lappend bdc " ";                    lappend targets $i}
	    "+" {lappend bdc " ";set startplayer $i; lappend targets $i}
	    "*" {lappend bdc " ";lappend startbox $i;lappend targets $i}
	}
	incr i
    }
    set q [list [list $startplayer $startbox] {}]
    set store([lindex $q 0]) {}
    for {set idx 0} {$idx < [llength $q]} {incr idx 2} {
	lassign [lindex $q $idx] x boxes
	foreach dir {U D L R} dx $dxes {
	    if {[set x1 [expr {$x + $dx}]] in $boxes} {
		if {[lindex $bdc [incr x1 $dx]] ne " " || $x1 in $boxes} {
		    continue
		}
		set tmpboxes $boxes
		set x1 [expr {$x + $dx}]
		for {set i 0} {$i < [llength $boxes]} {incr i} {
		    if {[lindex $boxes $i] == $x1} {
			lset tmpboxes $i [expr {$x1 + $dx}]
			break
		    }
		}
		if {$dx == 1 || $dx == -1} {
		    set next [list $x1 $tmpboxes]
		} else {
		    set next [list $x1 [lsort -integer $tmpboxes]]
		}
		if {![info exists store($next)]} {
		    if {$targets eq [lindex $next 1]} {
			foreach c [lindex $q [expr {$idx + 1}]] {
			    lassign $c ispush olddir
			    if {$ispush} {
				append solution $olddir
			    } else {
				append solution [string tolower $olddir]
			    }
			}
			return [append solution $dir]
		    }
		    set store($next) {}
		    set nm [lindex $q [expr {$idx + 1}]]
		    lappend q $next
		    lappend q [lappend nm [list 1 $dir]]
		}
	    } elseif {[lindex $bdc $x1] eq " "} {
		set next [list [expr {$x + $dx}] $boxes]
		if {![info exists store($next)]} {
		    set store($next) {}
		    set nm [lindex $q [expr {$idx + 1}]]
		    lappend q $next
		    lappend q [lappend nm [list 0 $dir]]
		}
	    }
	}
    }
    error "no solution"
}
