proc select {prompt choices} {
    set nc [llength $choices]
    if {!$nc} {
	return ""
    }
    set numWidth [string length $nc]
    while true {
	set i 0
	foreach s $choices {
	    puts [format "  %-*d: %s" $numWidth [incr i] $s]
	}
	puts -nonewline "$prompt: "
	flush stdout
	gets stdin num
	if {[string is int -strict $num] && $num >= 1 && $num <= $nc} {
	    incr num -1
	    return [lindex $choices $num]
	}
    }
}
