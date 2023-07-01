package require TclOO

oo::class create Player {
    variable me
    constructor {name} {
	set me $name
    }
    method name {} {
	return $me
    }

    method wantToRoll {safeScore roundScore} {}

    method rolled {who what} {
	if {$who ne [self]} {
	    #puts "[$who name] rolled a $what"
	}
    }
    method turnend {who score} {
	if {$who ne [self]} {
	    #puts "End of turn for [$who name] on $score"
	}
    }
    method winner {who score} {
	if {$who ne [self]} {
	    #puts "[$who name] is a winner, on $score"
	}
    }
}

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

proc rollDie {} {
    expr {1+int(rand() * 6)}
}
proc rotateList {var} {
    upvar 1 $var l
    set l [list {*}[lrange $l 1 end] [lindex $l 0]]
}
proc broadcast {players message score} {
    set p0 [lindex $players 0]
    foreach p $players {
	$p $message $p0 $score
    }
}

proc pig {args} {
    set players $args
    set scores [lrepeat [llength $args] 0]
    while 1 {
	set player [lindex $players 0]
	set safe [lindex $scores 0]
	set s 0
	while 1 {
	    if {$safe + $s >= 100} {
		incr safe $s
		$player won $safe
		broadcast $players winner $safe
		return $player
	    }
	    if {![$player wantToRoll $safe $s]} {
		lset scores 0 [incr safe $s]
		$player stuck $safe
		break
	    }
	    set roll [rollDie]
	    broadcast $players rolled $roll
	    if {$roll == 1} {
		$player busted $safe
		break
	    }
	    incr s $roll
	}
	broadcast $players turnend $safe
	rotateList players
	rotateList scores
    }
}
