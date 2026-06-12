package require TclOO

# Utility: pick random item of list
proc pick list {
    lindex $list [expr {int([llength $list] * rand())}]
}
# Utility: generate callback of method
proc callback {method args} {
    list [uplevel 1 {namespace current}]::my $method {*}$args
}
# Utility: print errors in events to standard error
proc bgerror args {puts stderr $args}

# The main class that implements the server
oo::class create BallMaze {
    variable grid balls x y dir carry turns identity chan timeout

    # Install this class as a server
    self method server {port width height args} {
	set srv [socket -server [callback new $width $height] {*}$args $port]
	if {$::debug} {
	    lassign [fconfigure $srv -sockname] addr host port
	    puts "server ready on ${addr}:${port}"
	}
    }

    # Initialize the per-player structure
    constructor {width height channel clientHost clientPort} {
	set identity "${clientHost}:${clientPort}"
	if {$::debug} {puts "$identity initializing..."}
	global width height
	set chan $channel
	fconfigure $chan -blocking 0 -encoding ascii
	set dir n
	set carry ""
	set turns 0

	# Build the grid
	set grid [set balls [lrepeat $width [lrepeat $height ""]]]

	# Make a layout of random colors
	for {set x 1} {$x < $width-1} {incr x} {
	    for {set y 1} {$y < $height-1} {incr y} {
		lset grid $x $y [pick {R G B Y}]
	    }
	}

	# Sprinkle some walls in
	for {set i 0} {$i < $width*$height/3} {incr i} {
	    while 1 {
		set x [expr {int(1+($width-2)*rand())}]
		set y [expr {int(1+($height-2)*rand())}]
		if {[lindex $grid $x $y] eq ""} continue
		if {[my WillCloseCell [expr {$x+1}] $y]} continue
		if {[my WillCloseCell [expr {$x-1}] $y]} continue
		if {[my WillCloseCell $x [expr {$y+1}]]} continue
		if {[my WillCloseCell $x [expr {$y-1}]]} continue
		break
	    }
	    lset grid $x $y ""
	}

	# Sprinkle some balls in
	for {set i 0} {$i < $width*$height/5} {incr i} {
	    while 1 {
		set x [expr {int(1+($width-2)*rand())}]
		set y [expr {int(1+($height-2)*rand())}]
		if {[lindex $grid $x $y] ne ""} break
	    }
	    lset balls $x $y [pick {R G B Y}]
	}

	# Select a starting location
	while 1 {
	    set x [expr {int(1+($width-2)*rand())}]
	    set y [expr {int(1+($height-2)*rand())}]
	    if {[lindex $grid $x $y] ne ""} break
	}
	set dir [pick {n s e w}]

	# OK, we're ready; wait for the client to be ready
	puts -nonewline $chan "A"
	fileevent $chan readable [callback PostInit]
	my SetTimeout
    }

    # Close things down (particularly the channel and the timeout; other state
    # is automatically killed with the object)
    destructor {
	if {$::debug} {puts "$identity closing down..."}
	catch {close $chan}
	catch {after cancel $timeout}
    }

    # How to (re)set the timeout
    method SetTimeout {} {
	catch {after cancel $timeout}
	set timeout [after 60000 [callback destroy]]
    }

    # Callback used to wait for the client to acknowledge readiness
    method PostInit {} {
	if {[read $chan 1] ne "A"} {
	    my destroy
	} else {
	    if {$::debug} {my print}
	    fileevent $chan readable [callback DispatchAction]
	    my SetTimeout
	}
    }

    # Utility: test if a cell will be closed by putting a wall next to it
    method WillCloseCell {i j} {
	set num 0
	incr num [expr {[lindex $grid [expr {$i+1}] $j] ne ""}]
	incr num [expr {[lindex $grid [expr {$i-1}] $j] ne ""}]
	incr num [expr {[lindex $grid $i [expr {$j+1}]] ne ""}]
	incr num [expr {[lindex $grid $i [expr {$j-1}]] ne ""}]
	return [expr {$num == 1}]
    }
    # Utility: is the game finished; all balls match, none in hand
    method IsGameOver {} {
	foreach gc $grid bc $balls {
	    foreach g $gc b $bc {
		if {$b ne "" && $b ne $g} {
		    return 0
		}
	    }
	}
	return [expr {$carry eq ""}]
    }

    # Main event handler; reads user action, dispatches, manages timeouts
    method DispatchAction {} {
	switch [read $chan 1] {
	    "^" {set events [my forward]}
	    "<" {set events [my left]}
	    ">" {set events [my right]}
	    "@" {set events [my get]}
	    "!" {set events [my drop]}
	    default {
		# EOF will come here too (read returns empty string)
		my destroy
		return
	    }
	}
	# Add the "stop" and send message to client
	append events "."
	puts -nonewline $chan $events
	my SetTimeout
    }

    # Implementations of particular actions; doesn't include communication
    method forward {} {
	switch $dir {
	    n {set dx 0; set dy -1}
	    s {set dx 0; set dy 1}
	    e {set dx 1; set dy 0}
	    w {set dx -1; set dy 0}
	}
	if {[lindex $grid [expr {$x+$dx}] [expr {$y+$dy}]] eq ""} {
	    set response "|"
	} else {
	    set response ""
	    incr turns
	    incr x $dx
	    incr y $dy
	}
	append response [lindex $grid $x $y]
	append response [string tolower [lindex $balls $x $y]]
	return $response
    }
    method left {} {
	set dir [string map {n w w s s e e n} $dir]
	incr turns
	return
    }
    method right {} {
	set dir [string map {n e e s s w w n} $dir]
	incr turns
	return
    }
    method get {} {
	incr turns
	set response ""
	if {[lindex $balls $x $y] eq ""} {append response "s"}
	if {$carry ne ""} {append response "A"}
	if {$response eq ""} {
	    set carry [lindex $balls $x $y]
	    lset balls $x $y ""
	}
	return $reponse
    }
    method drop {} {
	incr turns
	set response ""
	if {$carry eq ""} {append response "a"}
	if {[lindex $balls $x $y] ne ""} {append response "S"}
	if {$response eq ""} {
	    lset balls $x $y $carry
	    set carry ""
	    if {[my IsGameOver]} {
		if {$::debug} {my print}
		append response "+"
	    }
	}
	return $response
    }

    # Utility: prints the state of the service instance
    method print {} {
	set width [llength $grid]
	set height [llength [lindex $grid 0]]
	puts "$identity : [expr {[my IsGameOver] ? {finished} : {running}}]"
	for {set i 0} {$i < $height} {incr i} {
	    for {set j 0} {$j < $width} {incr j} {
		puts -nonewline [format "%1s%1s%1s" \
			[expr {$j==$x&&$i==$y ? "*" : ""}] \
			[lindex $grid $j $i] \
			[string tolower [lindex $balls $j $i]]]
	    }
	    puts ""
	}
    }
}

# Parse command line arguments and test if we're in debug mode
lassign $argv port width height
set debug [info exists env(DEBUG_AGENT_WORLD)]

# Make the server and run the event loop
BallMaze server $port $width $height {*}$argv
vwait forever
