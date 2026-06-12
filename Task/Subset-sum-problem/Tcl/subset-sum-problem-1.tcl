proc subsetsOfSize {set size} {
    if {$size <= 0} {
	return
    } elseif {$size == 1} {
	foreach elem $set {lappend result [list $elem]}
    } else {
	incr size [set i -1]
	foreach elem $set {
	    foreach sub [subsetsOfSize [lreplace $set [incr i] $i] $size] {
		lappend result [lappend sub $elem]
	    }
	}
    }
    return $result
}
proc searchForSubset {wordweights {minsize 1}} {
    set words [dict keys $wordweights]
    for {set i $minsize} {$i < [llength $words]} {incr i} {
	foreach subset [subsetsOfSize $words $i] {
	    set w 0
	    foreach elem $subset {incr w [dict get $wordweights $elem]}
	    if {!$w} {return $subset}
	}
    }
    # Nothing was found
    return -code error "no subset sums to zero"
}
