package require Tcl 8.6

oo::class create AgentAPI {
    variable sock events sectorColor ballColor
    constructor {host port} {
	set sock [socket $host $port]
	fconfigure $sock -buffering none -translation binary -encoding ascii \
	    -blocking 0
	# Hack to allow things to work in 8.6b1 and 8.6b2
        if {![llength [info commands yieldto]]} {
	    interp alias {} yieldto {} ::tcl::unsupported::yieldTo
	}
	coroutine ReaderCoroutine my ReadLoop
    }
    destructor {
	if {[llength [info command ReaderCoroutine]]} {
	    rename ReaderCoroutine {}
	}
	if {[llength [info command AgentCoroutine]]} {
	    rename AgentCoroutine {}
	}
	if {$sock ne ""} {
	    catch {close $sock}
	}
    }
    method Log message {
    }

    # Commands
    method ForwardStep {} {
	my Log "action: forward"
	puts -nonewline $sock "^"
	my ProcessEvents [yield]
    }
    method TurnRight {} {
	my Log "action: turn right"
	puts -nonewline $sock ">"
	my ProcessEvents [yield]
    }
    method TurnLeft {} {
	my Log "action: turn left"
	puts -nonewline $sock "<"
	my ProcessEvents [yield]
    }
    method GetBall {} {
	my Log "action: get ball"
	puts -nonewline $sock "@"
	my ProcessEvents [yield]
    }
    method DropBall {} {
	my Log "action: drop ball"
	puts -nonewline $sock "!"
	my ProcessEvents [yield]
    }
    method ProcessEvents {events} {
	set sectorColor {}
	set ballColor {}
	set err {}
	set done 0
	foreach e $events {
	    my Log "event: $e"
	    switch [lindex $e 0] {
		sector {set sectorColor [lindex $e 1]}
		ball {set ballColor [lindex $e 1]}
		error {set err [lindex $e 1]}
		gameOver {set done 1}
	    }
	}
	if {$err ne ""} {throw $err "can't do that: $err"}
	return $done
    }

    # Event demux
    method ReadLoop {} {
	# Init handshake
	fileevent $sock readable [info coroutine]
	while 1 {
	    yield
	    if {[read $sock 1] eq "A"} break
	}
	puts -nonewline $sock "A"
	# Main loop; agent logic is in coroutine
	try {
	    coroutine AgentCoroutine my Behavior
	    while 1 {
		yield
		set ch [read $sock 1]
		switch $ch {
		    "." {
			# Stop - end of events from move
			set e $events
			set events {}
			yieldto AgentCoroutine $e
			if {"gameOver" in $e} break
		    }
		    "+" {lappend events gameOver}
		    "R" {lappend events {sector red}}
		    "G" {lappend events {sector green}}
		    "Y" {lappend events {sector yellow}}
		    "B" {lappend events {sector blue}}
		    "r" {lappend events {ball red}}
		    "g" {lappend events {ball green}}
		    "y" {lappend events {ball yellow}}
		    "b" {lappend events {ball blue}}
		    "|" {lappend events {error bumpedWall}}
		    "S" {lappend events {error sectorFull}}
		    "A" {lappend events {error agentFull}}
		    "s" {lappend events {error sectorEmpty}}
		    "a" {lappend events {error agentEmpty}}
		}
	    }
	} finally {
	    close $sock
	    set sock ""
	}
    }

    method Behavior {} {
	error "method not implemented"
    }
}

# Export as package
package provide RC::RemoteAgent 1
