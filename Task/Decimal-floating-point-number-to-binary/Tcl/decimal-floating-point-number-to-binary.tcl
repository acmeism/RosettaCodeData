package require Tcl 8.6

proc dec2bin x {
    binary scan [binary format R $x] B* x
    regexp {(.)(.{8})(.{23})} $x -> s e m
    binary scan [binary format B* $e] cu e
    if {$e == 0 && ![string match *1* $m]} {
	# Special case for zero
	set m 0.0
    } else {
	incr e -127

	set m 1$m
	if {$e < 0} {
	    set m [string repeat "0" [expr {-$e}]]$m
	    set m [string trimright [regsub {^.} $m "&."] "0"]
	} else {
	    set m [string trimright [regsub ^.[string repeat . $e] $m "&."] "0"]
	}
	if {[string match *. $m]} {
	    append m 0
	}
    }
    if {$s} {
	return -$m
    } else {
	return $m
    }
}
proc bin2dec x {
    if {[regexp {^-} $x]} {
	set s 1
	set x [string trimleft $x -0]
    } else {
	set s 0
	set x [string trimleft $x +0]
    }
    lassign [split [string trimright $x 0] .] fore aft
    if {[string length $fore]} {
	set e [expr {[string length $fore] - 1}]
	set digits [string range $fore$aft 1 end]
    } elseif {[string length $aft]} {
	set digits [string range [string trimleft $aft 0] 1 end]
	set e [expr {[string length $digits] - [string length $aft]}]
    } else {
	set e -127
	set digits {}
    }
    incr e 127
    binary scan [binary format B* [format %b%08b%-023s $s $e $digits]] R x
    return $x
}

foreach case {77 0.25 0.15625 0.1 -33.8 0 1 2 3 23.34375 11.90625} {
    set b [dec2bin $case]
    set d [bin2dec $b]
    puts "$case => $b => $d"
}
