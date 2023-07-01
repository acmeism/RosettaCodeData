proc josephus {number step {survivors 1}} {
    for {set i 0} {$i<$number} {incr i} {lappend l $i}
    for {set i 1} {[llength $l]} {incr i} {
	# If the element is to be killed, append to the kill sequence
	if {$i%$step == 0} {
	    lappend killseq [lindex $l 0]
	    set l [lrange $l 1 end]
	} else {
	    # Roll the list
	    set l [concat [lrange $l 1 end] [list [lindex $l 0]]]
	}
    }
    return [lrange $killseq end-[expr {$survivors-1}] end]
}
