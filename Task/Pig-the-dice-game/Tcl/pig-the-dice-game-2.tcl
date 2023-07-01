oo::class create HumanPlayer {
    variable me
    superclass Player
    method wantToRoll {safeScore roundScore} {
	while 1 {
	    puts -nonewline "$me (on $safeScore+$roundScore) do you want to roll? (Y/n)"
	    flush stdout
	    if {[gets stdin line] < 0} {
		# EOF detected
		puts ""
		exit
	    }
	    if {$line eq "" || $line eq "y" || $line eq "Y"} {
		return 1
	    }
	    if {$line eq "n" || $line eq "N"} {
		return 0
	    }
	}
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

pig [HumanPlayer new "Alex"] [HumanPlayer new "Bert"]
