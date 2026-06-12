package require TclOO

#http://rosettacode.org/wiki/Keyboard_Input/Obtain_a_Y_or_N_response#Tcl
proc yesno {{message "Press Y or N to continue"}} {
    fconfigure stdin -blocking 0
    exec stty raw
    read stdin ; # flush
    puts -nonewline "${message}: "
    flush stdout
    while {![eof stdin]} {
        set c [string tolower [read stdin 1]]
        if {$c eq "y" || $c eq "n"} break
    }
    puts [string toupper $c]
    exec stty -raw
    fconfigure stdin -blocking 1
    return [expr {$c eq "y"}]
}

oo::class create DecisionTable {
    variable qlist responses
    constructor {questions responseMap} {
	set qlist $questions
	set responses $responseMap
    }

    method consult {} {
	set idx 0
	foreach q $qlist {
	    set answer [yesno "$q? \[y/n\]"]
	    set idx [expr {$idx*2 + (1-$answer)}]
	}
	foreach {msg map} $responses {
	    # Allow a column to be omitted; magic!
	    if {"0[lindex $map $idx]"} {
		puts $msg
	    }
	}
    }
}
