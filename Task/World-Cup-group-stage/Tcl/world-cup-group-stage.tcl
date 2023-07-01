package require Tcl 8.6
proc groupStage {} {
    foreach n {0 1 2 3} {
	set points($n) {0 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0}
    }
    set results 0
    set games {0 1 0 2 0 3 1 2 1 3 2 3}
    while true {
	set R {0 0 1 0 2 0 3 0}
	foreach r [split [format %06d $results] ""] {A B} $games {
	    switch $r {
		2 {dict incr R $A 3}
		1 {dict incr R $A; dict incr R $B}
		0 {dict incr R $B 3}
	    }
	}
	foreach n {0 1 2 3} r [lsort -integer [dict values $R]] {
	    dict incr points($n) $r
	}

	if {$results eq "222222"} break
	while {[regexp {[^012]} [incr results]]} continue
    }
    return [lmap n {3 2 1 0} {dict values $points($n)}]
}

foreach nth {First Second Third Fourth} nums [groupStage] {
    puts "$nth place:\t[join [lmap n $nums {format %3s $n}] {, }]"
}
