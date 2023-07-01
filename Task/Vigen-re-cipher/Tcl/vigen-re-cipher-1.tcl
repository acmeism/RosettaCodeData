package require Tcl 8.6

oo::class create Vigenere {
    variable key
    constructor {protoKey} {
	foreach c [split $protoKey ""] {
	    if {[regexp {[A-Za-z]} $c]} {
		lappend key [scan [string toupper $c] %c]
	    }
	}
    }

    method encrypt {text} {
	set out ""
	set j 0
	foreach c [split $text ""] {
	    if {[regexp {[^a-zA-Z]} $c]} continue
	    scan [string toupper $c] %c c
	    append out [format %c [expr {($c+[lindex $key $j]-130)%26+65}]]
	    set j [expr {($j+1) % [llength $key]}]
	}
	return $out
    }

    method decrypt {text} {
	set out ""
	set j 0
	foreach c [split $text ""] {
	    if {[regexp {[^A-Z]} $c]} continue
	    scan $c %c c
	    append out [format %c [expr {($c-[lindex $key $j]+26)%26+65}]]
	    set j [expr {($j+1) % [llength $key]}]
	}
	return $out
    }
}
