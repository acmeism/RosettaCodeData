proc rank {rankingMethod sortedList} {
    # Extract the groups in the data (this is pointless for ordinal...)
    set s [set group [set groups {}]]
    foreach {score who} $sortedList {
	if {$score != $s} {
	    lappend groups [llength $group]
	    set s $score
	    set group {}
	}
	lappend group $who
    }
    lappend groups [llength $group]
    # Construct the rankings; note that we have a zero-sized leading group
    set n 1; set m 0
    foreach g $groups {
	switch $rankingMethod {
	    standard {
		lappend result {*}[lrepeat $g $n]
		incr n $g
	    }
	    modified {
		lappend result {*}[lrepeat $g [incr m $g]]
	    }
	    dense {
		lappend result {*}[lrepeat $g $m]
		incr m
	    }
	    ordinal {
		for {set i 0} {$i < $g} {incr i} {
		    lappend result [incr m]
		}
	    }
	    fractional {
		set val [expr {($n + [incr n $g] - 1) / 2.0}]
		lappend result {*}[lrepeat $g [format %g $val]]
	    }
	}
    }
    return $result
}

set data {
    44 Solomon
    42 Jason
    42 Errol
    41 Garry
    41 Bernard
    41 Barry
    39 Stephen
}
foreach method {standard modified dense ordinal fractional} {
    puts "Using method '$method'...\n  Rank\tScore\tWho"
    foreach rank [rank $method $data] {score who} $data {
	puts "  $rank\t$score\t$who"
    }
}
