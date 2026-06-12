# Custom assertions; names stolen from Eiffel keywords
proc require {expression message args} {
    if {![uplevel 1 [list expr $expression]]} {
	set msg [uplevel 1 [list format $message] $args]
	return -level 2 -code error "PRECONDITION FAILED: $msg"
    }
}
proc ensure {expression {message ""} args} {
    if {![uplevel 1 [list expr $expression]]} {
	set msg [uplevel 1 [list format $message] $args]
	return -level 2 -code error "POSTCONDITION FAILED: $msg"
    }
}

proc connect_to_server {server port} {
    require {$server ne ""} "server address must not be empty"
    require {[string is integer -strict $port]} "port must be numeric"
    require {$port > 0 && $port < 65536} "port must be valid for client"

    set sock [socket $server $port]

    # Will never fail: Tcl *actually* throws an error on connection
    # failure instead, but the principle still holds.
    ensure {$sock ne ""} "a socket should have been created"

    return $sock
}
