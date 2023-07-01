# Fairly simple version; only counts by 3 and 5, skipping intermediates
proc mul35sum {n} {
    for {set total [set threes [set fives 0]]} {$threes<$n||$fives<$n} {} {
	if {$threes<$fives} {
	    incr total $threes
	    incr threes 3
	} elseif {$threes>$fives} {
	    incr total $fives
	    incr fives 5
	} else {
	    incr total $threes
	    incr threes 3
	    incr fives 5
	}
    }
    return $total
}
