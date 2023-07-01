package require Tcl 8.6; # Just for tailcall command
# Builds a value-capturing closure; does NOT couple variables
proc closure {script} {
    set valuemap {}
    foreach v [uplevel 1 {info vars}] {
	lappend valuemap [list $v [uplevel 1 [list set $v]]]
    }
    set body [list $valuemap $script [uplevel 1 {namespace current}]]
    # Wrap, to stop untoward argument passing
    return [list apply [list {} [list tailcall apply $body]]]
    # A version of the previous line compatible with Tcl 8.5 would be this
    # code, but the closure generated is more fragile:
    ### return [list apply $body]
}

# Simple helper, to avoid capturing unwanted variable
proc collectFor {var from to body} {
    upvar 1 $var v
    set result {}
    for {set v $from} {$v < $to} {incr v} {lappend result [uplevel 1 $body]}
    return $result
}
# Build a list of closures
proc buildList {} {
    collectFor i 0 10 {
	closure {
	    # This is the body of the closure
	    return [expr $i*$i]
	}
    }
}
set theClosures [buildList]
foreach i {a b c d e} {# Do 5 times; demonstrates no variable leakage
    set idx [expr {int(rand()*9)}]; # pick random int from [0..9)
    puts $idx=>[{*}[lindex $theClosures $idx]]
}
