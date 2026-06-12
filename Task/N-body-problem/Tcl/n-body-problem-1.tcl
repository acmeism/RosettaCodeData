package require Tcl 8.6

set G 0.01
set epsilon 1e-12

proc acceleration.gravity {positions masses} {
    global G epsilon
    set i -1
    lmap position $positions mass $masses {
	incr i
	set dp2 [lmap p $position {expr 0.0}]
	set j -1
	foreach pj $positions mj $masses {
	    if {[incr j] == $i} continue
	    set dp [lmap p1 $position p2 $pj {expr {$p1-$p2}}]
	    set d3 [expr {
		sqrt(
		    [tcl::mathop::+ {*}[lmap p $dp {expr {$p ** 2}}]]
		    + $epsilon
		) ** 3
	    }]
	    # Add epsilon here?
	    set dp2 [lmap a $dp2 b $dp {expr {$a - $G*$mj*$b/$d3}}]
	}
	set dp2
    }
}

# The rest of the system; simple numeric solution of differential equations
proc velocity {velocities accelerations} {
    lmap v $velocities a $accelerations {
	lmap vi $v ai $a {expr {$vi + $ai}}
    }
}
proc position {positions velocities} {
    lmap p $positions v $velocities {
	lmap pi $p vi $v {expr {$pi + $vi}}
    }
}
proc timestep {masses positions velocities} {
    set accelerations [acceleration.gravity $positions $masses]
    set velocities [velocity $velocities $accelerations]
    set positions [position $positions $velocities]
    list $positions $velocities
}

# Combine to make a simulation engine
proc simulate {masses positions velocities {steps 10}} {
    set p $positions
    set v $velocities
    for {set i 0} {$i < $steps} {incr i} {
	lassign [timestep $masses $p $v] p v
	puts [lmap pos $p {format (%.5f,%.5f,%.5f) {*}$pos}]
    }
}
