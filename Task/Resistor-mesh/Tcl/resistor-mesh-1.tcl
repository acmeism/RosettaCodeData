package require Tcl 8.6;  # Or 8.5 with the TclOO package

# This code is structured as a class with a little trivial DSL parser so it is
# easy to change what problem is being worked on.
oo::class create ResistorMesh {
    variable forcePoints V fixed w h

    constructor {boundaryConditions} {
	foreach {op condition} $boundaryConditions {
	    switch $op {
		size {
		    lassign $condition w h
		    set fixed [lrepeat $h [lrepeat $w 0]]
		    set V [lrepeat $h [lrepeat $w 0.0]]
		}
		fixed {
		    lassign $condition j i v
		    lset fixed $i $j [incr ctr]
		    lappend forcePoints $j $i $v
		}
	    }
	}
    }

    method CalculateDifferences {*dV} {
	upvar 1 ${*dV} dV
	set error 0.0
	for {set i 0} {$i < $h} {incr i} {
	    for {set j 0} {$j < $w} {incr j} {
		set v 0.0
		set n 0
		if {$i} {
		    set v [expr {$v + [lindex $V [expr {$i-1}] $j]}]
		    incr n
		}
		if {$j} {
		    set v [expr {$v + [lindex $V $i [expr {$j-1}]]}]
		    incr n
		}
		if {$i+1 < $h} {
		    set v [expr {$v + [lindex $V [expr {$i+1}] $j]}]
		    incr n
		}
		if {$j+1 < $w} {
		    set v [expr {$v + [lindex $V $i [expr {$j+1}]]}]
		    incr n
		}
		lset dV $i $j [set v [expr {[lindex $V $i $j] - $v/$n}]]
		if {![lindex $fixed $i $j]} {
		    set error [expr {$error + $v**2}]
		}
	    }
	}
	return $error
    }

    method FindCurrentFixpoint {epsilon} {
	set dV [lrepeat $h [lrepeat $w 0.0]]
	set current {0.0 0.0 0.0}
	while true {
	    # Enforce the boundary conditions
	    foreach {j i v} $forcePoints {
		lset V $i $j $v
	    }
	    # Compute the differences and the error
	    set error [my CalculateDifferences dV]
	    # Apply the differences
	    for {set i 0} {$i < $h} {incr i} {
		for {set j 0} {$j < $w} {incr j} {
		    lset V $i $j [expr {
			[lindex $V $i $j] - [lindex $dV $i $j]}]
		}
	    }
	    # Done if the error is small enough
	    if {$error < $epsilon} break
	}
	# Compute the currents from the error
	for {set i 0} {$i < $h} {incr i} {
	    for {set j 0} {$j < $w} {incr j} {
		lset current [lindex $fixed $i $j] [expr {
		    [lindex $current [lindex $fixed $i $j]] +
		    [lindex $dV $i $j] * (!!$i+!!$j+($i<$h-1)+($j<$w-1))}]
	    }
	}
	# Compute the actual current flowing between source and sink
	return [expr {([lindex $current 1] - [lindex $current 2]) / 2.0}]
    }

    # Public entry point
    method solveForResistance {{epsilon 1e-24}} {
	set voltageDifference [expr {
	    [lindex $forcePoints 2] - [lindex $forcePoints 5]}]
	expr {$voltageDifference / [my FindCurrentFixpoint $epsilon]}
    }
}
