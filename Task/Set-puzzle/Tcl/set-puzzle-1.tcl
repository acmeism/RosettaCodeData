# Generate random integer uniformly on range [0..$n-1]
proc random n {expr {int(rand() * $n)}}

# Generate a shuffled deck of all cards; the card encoding was stolen from the
# Perl6 solution. This is done once and then used as a constant. Note that the
# rest of the code assumes that all cards in the deck are unique.
set ::AllCards [apply {{} {
    set cards {}
    foreach color {1 2 4} {
	foreach symbol {1 2 4} {
	    foreach number {1 2 4} {
		foreach shading {1 2 4} {
		    lappend cards [list $color $symbol $number $shading]
		}
	    }
	}
    }
    # Knuth-Morris-Pratt shuffle (not that it matters)
    for {set i [llength $cards]} {$i > 0} {} {
	set j [random $i]
	set tmp [lindex $cards [incr i -1]]
	lset cards $i [lindex $cards $j]
	lset cards $j $tmp
    }
    return $cards
}}]

# Randomly pick a hand of cards from the deck (itself in a global for
# convenience).
proc drawCards n {
    set cards $::AllCards;    # Copies...
    for {set i 0} {$i < $n} {incr i} {
	set idx [random [llength $cards]]
	lappend hand [lindex $cards $idx]
	set cards [lreplace $cards $idx $idx]
    }
    return $hand
}

# Test if a particular group of three cards is a valid set
proc isValidSet {a b c} {
    expr {
	  ([lindex $a 0]|[lindex $b 0]|[lindex $c 0]) in {1 2 4 7} &&
	  ([lindex $a 1]|[lindex $b 1]|[lindex $c 1]) in {1 2 4 7} &&
	  ([lindex $a 2]|[lindex $b 2]|[lindex $c 2]) in {1 2 4 7} &&
	  ([lindex $a 3]|[lindex $b 3]|[lindex $c 3]) in {1 2 4 7}
    }
}

# Get all unique valid sets of three cards in a hand.
proc allValidSets {hand} {
    set sets {}
    for {set i 0} {$i < [llength $hand]} {incr i} {
	set a [lindex $hand $i]
	set hand [set cards2 [lreplace $hand $i $i]]
	for {set j 0} {$j < [llength $cards2]} {incr j} {
	    set b [lindex $cards2 $j]
	    set cards2 [set cards3 [lreplace $cards2 $j $j]]
	    foreach c $cards3 {
		if {[isValidSet $a $b $c]} {
		    lappend sets [list $a $b $c]
		}
	    }
	}
    }
    return $sets
}

# Solve a particular version of the set puzzle, by picking random hands until
# one is found that satisfies the constraints. This is usually much faster
# than a systematic search. On success, returns the hand found and the card
# sets within that hand.
proc SetPuzzle {numCards numSets} {
    while 1 {
	set hand [drawCards $numCards]
	set sets [allValidSets $hand]
	if {[llength $sets] == $numSets} {
	    break
	}
    }
    return [list $hand $sets]
}
