package require Tcl 8.6

oo::class create Player {
    variable who seq seen idx

    constructor {name sequence} {
	set who $name
	set seq $sequence
	set seen {}
	set idx end-[expr {[string length $seq] - 1}]
    }

    method pick {} {
	return $seq
    }

    method name {} {
	return $who
    }

    method match {digit} {
	append seen $digit
	return [expr {[string range $seen $idx end] eq $seq}]
    }
}

oo::class create HumanPlayer {
    superclass Player
    constructor {length {otherPlayersSelection ""}} {
	fconfigure stdout -buffering none
	while true {
	    puts -nonewline "What do you pick? (length $length): "
	    if {[gets stdin pick] < 0} exit
	    set pick [regsub -all {[^HT]} [string map {0 H 1 T h H t T} $pick] ""]
	    if {[string length $pick] eq $length} break
	    puts "That's not a legal pick!"
	}
	set name "Human"
	if {[incr ::humans] > 1} {append name " #$::humans"}
	next $name $pick
    }
}

oo::class create RobotPlayer {
    superclass Player
    constructor {length {otherPlayersSelection ""}} {
	if {$otherPlayersSelection eq ""} {
	    set pick ""
	    for {set i 0} {$i < $length} {incr i} {
		append pick [lindex {H T} [expr {int(rand()*2)}]]
	    }
	} else {
	    if {$length != 3} {
		error "lengths other than 3 not implemented"
	    }
	    lassign [split $otherPlayersSelection ""] a b c
	    set pick [string cat [string map {H T T H} $b] $a $b]
	}
	set name "Robot"
	if {[incr ::robots] > 1} {append name " #$::robots"}
	puts "$name picks $pick"
	next $name $pick
    }
}

proc game {length args} {
    puts "Let's play Penney's Game!"

    # instantiate the players
    set picks {}
    set players {}
    while {[llength $args]} {
	set idx [expr {int(rand()*[llength $args])}]
	set p [[lindex $args $idx] new $length {*}$picks]
	set args [lreplace $args $idx $idx]
	lappend players $p
	lappend picks [$p pick]
    }

    # sanity check
    if {[llength $picks] != [llength [lsort -unique $picks]]} {
	puts "Two players picked the same thing; that's illegal"
    }

    # do the game loop
    while 1 {
	set coin [lindex {H T} [expr {int(rand()*2)}]]
	puts "Coin flip [incr counter] is $coin"
	foreach p $players {
	    if {[$p match $coin]} {
		puts "[$p name] has won!"
		return
	    }
	}
    }
}

game 3 HumanPlayer RobotPlayer
