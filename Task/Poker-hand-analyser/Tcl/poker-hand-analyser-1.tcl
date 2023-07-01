package require Tcl 8.6
namespace eval PokerHandAnalyser {
    proc analyse {hand} {
	set norm [Normalise $hand]
	foreach type {
	    invalid straight-flush four-of-a-kind full-house flush straight
	    three-of-a-kind two-pair one-pair
	} {
	    if {[Detect-$type $norm]} {
		return $type
	    }
	}
	# Always possible to use high-card if the hand is legal at all
	return high-card
    }

    # This normalises to an internal representation that is a list of pairs,
    # where each pair is one number for the pips (ace == 14, king == 13,
    # etc.) and another for the suit. This greatly simplifies detection.
    proc Normalise {hand} {
	set PipMap {j 11 q 12 k 13 a 14}
	set SuitMap {♥ 2 h 2 ♦ 1 d 1 ♣ 0 c 0 ♠ 3 s 3}
	set hand [string tolower $hand]
	set cards [regexp -all -inline {(?:[akqj98765432]|10)[hdcs♥♦♣♠]} $hand]
	lsort -command CompareCards [lmap c [string map {} $cards] {
	    list [string map $PipMap [string range $c 0 end-1]] \
		    [string map $SuitMap [string index $c end]]
	}]
    }
    proc CompareCards {a b} {
	lassign $a pipA suitA
	lassign $b pipB suitB
	expr {$pipA==$pipB ? $suitB-$suitA : $pipB-$pipA}
    }

    # Detection code. Note that the detectors all assume that the preceding
    # detectors have been run first; this simplifies the logic a lot, but does
    # mean that the individual detectors are not robust on their own.
    proc Detect-invalid {hand} {
	if {[llength $hand] != 5} {return 1}
	foreach c $hand {
	    if {[incr seen($c)] > 1} {return 1}
	}
	return 0
    }
    proc Detect-straight-flush {hand} {
	foreach c $hand {
	    lassign $c pip suit
	    if {[info exist prev] && $prev-1 != $pip} {
		# Special case: ace low straight flush ("steel wheel")
		if {$prev != 14 && $suit != 5} {
		    return 0
		}
	    }
	    set prev $pip
	    incr seen($suit)
	}
	return [expr {[array size seen] == 1}]
    }
    proc Detect-four-of-a-kind {hand} {
	foreach c $hand {
	    lassign $c pip suit
	    if {[incr seen($pip)] > 3} {return 1}
	}
	return 0
    }
    proc Detect-full-house {hand} {
	foreach c $hand {
	    lassign $c pip suit
	    incr seen($pip)
	}
	return [expr {[array size seen] == 2}]
    }
    proc Detect-flush {hand} {
	foreach c $hand {
	    lassign $c pip suit
	    incr seen($suit)
	}
	return [expr {[array size seen] == 1}]
    }
    proc Detect-straight {hand} {
	foreach c $hand {
	    lassign $c pip suit
	    if {[info exist prev] && $prev-1 != $pip} {
		# Special case: ace low straight ("wheel")
		if {$prev != 14 && $suit != 5} {
		    return 0
		}
	    }
	    set prev $pip
	}
	return 1
    }
    proc Detect-three-of-a-kind {hand} {
	foreach c $hand {
	    lassign $c pip suit
	    if {[incr seen($pip)] > 2} {return 1}
	}
	return 0
    }
    proc Detect-two-pair {hand} {
	set pairs 0
	foreach c $hand {
	    lassign $c pip suit
	    if {[incr seen($pip)] > 1} {incr pairs}
	}
	return [expr {$pairs > 1}]
    }
    proc Detect-one-pair {hand} {
	foreach c $hand {
	    lassign $c pip suit
	    if {[incr seen($pip)] > 1} {return 1}
	}
	return 0
    }
}
