package require Tcl 8.6
package require RC::RemoteAgent

oo::class create Agent {
    superclass AgentAPI
    variable sectorColor ballColor
    forward Behavior my MoveBehavior

    # How to move around
    method MoveBehavior {} {
	set ball ""
	while 1 {
	    try {
		while {rand() < 0.5} {
		    my ForwardStep
		    my BallBehavior
		}
	    } trap bumpedWall {} {}
	    if {rand() < 0.5} {
		my TurnLeft
	    } else {
		my TurnRight
	    }
	}
	set ::wonGame ok
    }

    # How to handle the ball once we've arrived in a square
    method BallBehavior {} {
	upvar 1 ball ball anywhere anywhere
	if {
	    $ball eq ""
	    && $ballColor ne ""
	    && $ballColor ne $sectorColor
	} then {
	    set ball [set ballTarget $ballColor]
	    set anywhere 0
	    my GetBall
	} elseif {
	    $ball ne ""
	    && ($ball eq $sectorColor || $anywhere)
	} {
	    try {
		if {[my DropBall]} {
		    return -code break
		}
		set ball ""
	    } trap sectorFull {} {
		# Target square full; drop this ball anywhere
		set anywhere 1
	    }
	}
    }
}

Agent new "localhost" 12345
vwait wonGame
