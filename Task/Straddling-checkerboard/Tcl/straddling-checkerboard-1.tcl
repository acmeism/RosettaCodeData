package require Tcl 8.6

oo::class create StraddlingCheckerboardCypher {
    variable encmap decmap
    constructor table {
	# Sanity check the table
	foreach ch [lindex $table 0] i {"" 0 1 2 3 4 5 6 7 8 9} {
	    if {$ch eq "" && $i ne "" && [lsearch -index 0 $table $i] < 1} {
		error "bad checkerboard table"
	    }
	}
	# Synthesize the escaped number row
	foreach row $table {
	    if {"/" ni $row} continue
	    set pfx [lindex $row 0][expr {[lsearch -exact $row "/"]-1}]
	    lappend table [list $pfx 0 1 2 3 4 5 6 7 8 9]
	    break
	}
	# Build the actual per-character mapping
	foreach row $table {
	    foreach ch [lrange $row 1 end] n {0 1 2 3 4 5 6 7 8 9} {
		if {$ch in {"" "/"}} continue;  # Skip escape cases
		lappend encmap $ch [lindex $row 0]$n
		lappend decmap [lindex $row 0]$n $ch
	    }
	}
    }

    # These methods just sanitize their input and apply the map
    method encode msg {
	string map $encmap [regsub -all {[^A-Z0-9.]} [string toupper $msg] ""]
    }
    method decode msg {
	string map $decmap [regsub -all {[^0-9]} $msg ""]
    }
}
