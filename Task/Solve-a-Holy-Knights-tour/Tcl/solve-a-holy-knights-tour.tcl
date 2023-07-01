package require Tcl 8.6

oo::class create HKTSolver {
    variable grid start limit
    constructor {puzzle} {
	set grid $puzzle
	for {set y 0} {$y < [llength $grid]} {incr y} {
	    for {set x 0} {$x < [llength [lindex $grid $y]]} {incr x} {
		if {[set cell [lindex $grid $y $x]] == 1} {
		    set start [list $y $x]
		}
		incr limit [expr {$cell>=0}]
	    }
	}
	if {![info exist start]} {
	    return -code error "no starting position found"
	}
    }
    method moves {} {
	return {
	        -1 -2   1 -2
	    -2 -1          2 -1
	    -2  1          2 1
	        -1 2    1 2
	}
    }
    method Moves {g r c} {
	set valid {}
	foreach {dr dc} [my moves] {
	    set R [expr {$r + $dr}]
	    set C [expr {$c + $dc}]
	    if {[lindex $g $R $C] == 0} {
		lappend valid $R $C
	    }
	}
	return $valid
    }

    method Solve {g r c v} {
	lset g $r $c [incr v]
	if {$v >= $limit} {return $g}
	foreach {r c} [my Moves $g $r $c] {
	    return [my Solve $g $r $c $v]
	}
	return -code continue
    }

    method solve {} {
	while {[incr i]==1} {
	    set grid [my Solve $grid {*}$start 0]
	    return
	}
	return -code error "solution not possible"
    }
    method solution {} {return $grid}
}

proc parsePuzzle {str} {
    foreach line [split $str "\n"] {
	if {[string trim $line] eq ""} continue
	lappend rows [lmap {- c} [regexp -all -inline {(.)\s?} $line] {
	    string map {" " -1} $c
	}]
    }
    set len [tcl::mathfunc::max {*}[lmap r $rows {llength $r}]]
    for {set i 0} {$i < [llength $rows]} {incr i} {
	while {[llength [lindex $rows $i]] < $len} {
	    lset rows $i end+1 -1
	}
    }
    return $rows
}
proc showPuzzle {grid name} {
    foreach row $grid {foreach cell $row {incr c [expr {$cell>=0}]}}
    set len [string length $c]
    set u [string repeat "_" $len]
    puts "$name with $c cells"
    foreach row $grid {
	puts [format "  %s" [join [lmap c $row {
	    format "%*s" $len [if {$c==-1} list elseif {$c==0} {set u} {set c}]
	}]]]
    }
}

set puzzle [parsePuzzle {
  0 0 0
  0   0 0
  0 0 0 0 0 0 0
0 0 0     0   0
0   0     0 0 0
1 0 0 0 0 0 0
    0 0   0
      0 0 0
}]
showPuzzle $puzzle "Input"
HKTSolver create hkt $puzzle
hkt solve
showPuzzle [hkt solution] "Output"
