oo::class create RoboPlayer {
    superclass Player
    variable me
    constructor {name} {
	# Add a symbol to the name to mark a robot...
	next "$name\u00ae"
    }
    method wantToRoll {safeScore roundScore} {
	puts -nonewline "$me has ($safeScore,$roundScore)... "
	set decision [my Decide $safeScore $roundScore]
	puts [lindex {stick roll} $decision]
	return $decision
    }
    method stuck {score} {
	puts "$me sticks with score $score"
    }
    method busted {score} {
	puts "Busted! ($me still on score $score)"
    }
    method won {score} {
	puts "$me has won! (Score: $score)"
    }
}

# Just takes a random decision as to what to play
oo::class create RandomPlayer {
    superclass RoboPlayer
    constructor {} {next "Random"}
    method Decide {a b} {expr {rand() < 0.5}}
}

# Rolls until it scores at least 20 from a round or goes bust
oo::class create To20Player {
    superclass RoboPlayer
    constructor {} {next "To20"}
    method Decide {safeScore roundScore} {expr {$roundScore < 20}}
}

# Like To20, but will roll desperately once another player reaches 80
oo::class create Desperate {
    superclass RoboPlayer
    variable me scores
    constructor {} {
	next "Desperate"
	set scores {}
    }

    method Decide {safeScore roundScore} {
	dict for {who val} $scores {
	    if {$who ne [self] && $val >= 80} {
		return 1
	    }
	}
	return [expr {$roundScore < 20}]
    }
    # Keep an eye on other players
    method turnend {who score} {
	next $who $score
	dict set scores $who $score
    }
}
