#
### Create a thiele-interpretation function with the given name that interpolates
### off the given table.
#
proc thiele {name : X -> F} {
    # Sanity check
    if {[llength $X] != [llength $F]} {
	error "unequal length lists supplied: [llength $X] != [llength $F]"
    }

    #
    ### Compute the table of reciprocal differences
    #
    set p [lrepeat [llength $X] [lrepeat [llength $X] 0.0]]
    set i 0
    foreach x0 [lrange $X 0 end-1] x1 [lrange $X 1 end] \
	    f0 [lrange $F 0 end-1] f1 [lrange $F 1 end] {
	lset p $i 0 $f0
	lset p $i 1 [expr {($x0 - $x1) / ($f0 - $f1)}]
	lset p [incr i] 0 $f1
    }
    for {set j 2} {$j<[llength $X]-1} {incr j} {
	for {set i 0} {$i<[llength $X]-$j} {incr i} {
	    lset p $i $j [expr {
		[lindex $p $i+1 $j-2] +
		([lindex $X $i] - [lindex $X $i+$j]) /
		([lindex $p $i $j-1] - [lindex $p $i+1 $j-1])
	    }]
	}
    }

    #
    ### Make pseudo-curried function that actually evaluates Thiele's formula
    #
    interp alias {} $name {} apply {{X rho f1 x} {
	set a 0.0
	foreach Xi  [lreverse [lrange $X 2 end]] \
		Ri  [lreverse [lrange $rho 2 end]] \
		Ri2 [lreverse [lrange $rho 0 end-2]] {
	    set a [expr {($x - $Xi) / ($Ri - $Ri2 + $a)}]
	}
	expr {$f1 + ($x - [lindex $X 1]) / ([lindex $rho 1] + $a)}
    }} $X [lindex $p 1] [lindex $F 1]
}
