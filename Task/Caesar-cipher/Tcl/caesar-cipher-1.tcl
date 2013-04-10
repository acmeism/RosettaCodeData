package require Tcl 8.6;    # Or TclOO package for 8.5

oo::class create Caesar {
    variable encryptMap decryptMap
    constructor shift {
	for {set i 0} {$i < 26} {incr i} {
	    # Play fast and loose with string/list duality for shorter code
	    append encryptMap [format "%c %c %c %c " \
		    [expr {$i+65}] [expr {($i+$shift)%26+65}] \
		    [expr {$i+97}] [expr {($i+$shift)%26+97}]]
	    append decryptMap [format "%c %c %c %c " \
		    [expr {$i+65}] [expr {($i-$shift)%26+65}] \
		    [expr {$i+97}] [expr {($i-$shift)%26+97}]]
	}
    }

    method encrypt text {
	string map $encryptMap $text
    }
    method decrypt text {
	string map $decryptMap $text
    }
}
