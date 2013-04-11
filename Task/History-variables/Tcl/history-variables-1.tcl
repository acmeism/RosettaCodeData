# Define the history machinery
proc histvar {varName operation} {
    upvar 1 $varName v ___history($varName) history
    switch -- $operation {
	start {
	    set history {}
	    if {[info exist v]} {
		lappend history $v
	    }
	    trace add variable v write [list histvar.write $varName]
	    trace add variable v read [list histvar.read $varName]
	}
	list {
	    return $history
	}
	undo {
	    set history [lrange $history 0 end-1]
	}
	stop {
	    unset history
	    trace remove variable v write [list histvar.write $varName]
	    trace remove variable v read [list histvar.read $varName]
	}
    }
}
proc histvar.write {key varName args} {
    upvar 1 $varName v ___history($key) history
    lappend history $v
}
proc histvar.read {key varName args} {
    upvar 1 $varName v ___history($key) history
    set v [lindex $history end]
}
