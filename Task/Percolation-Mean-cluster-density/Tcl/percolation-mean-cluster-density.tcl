package require Tcl 8.6

proc determineClusters {w h p} {
    # Construct the grid
    set grid [lrepeat $h [lrepeat $w 0]]
    for {set i 0} {$i < $h} {incr i} {
	for {set j 0} {$j < $w} {incr j} {
	    lset grid $i $j [expr {rand() < $p ? -1 : 0}]
	}
    }
    # Find (and count) the clusters
    set cl 0
    for {set i 0} {$i < $h} {incr i} {
	for {set j 0} {$j < $w} {incr j} {
	    if {[lindex $grid $i $j] == -1} {
		incr cl
		for {set q [list $i $j];set k 0} {$k<[llength $q]} {incr k} {
		    set y [lindex $q $k]
		    set x [lindex $q [incr k]]
		    if {[lindex $grid $y $x] != -1} continue
		    lset grid $y $x $cl
		    foreach dx {1 0 -1 0} dy {0 1 0 -1} {
			set nx [expr {$x+$dx}]
			set ny [expr {$y+$dy}]
			if {
			    $nx >= 0 && $ny >= 0 && $nx < $w && $ny < $h &&
			    [lindex $grid $ny $nx] == -1
			} then {
			    lappend q $ny $nx
			}
		    }
		}
	    }
	}
    }
    return [list $cl $grid]
}

# Print a sample 15x15 grid
lassign [determineClusters 15 15 0.5] n g
puts "15x15 grid, p=0.5, with $n clusters"
puts "+[string repeat - 15]+"
foreach r $g {puts |[join [lmap x $r {format %c [expr {$x==0?32:64+$x}]}] ""]|}
puts "+[string repeat - 15]+"

# Determine the densities as the grid size increases
puts "p=0.5, iter=5"
foreach n {5 30 180 1080 6480} {
    set tot 0
    for {set i 0} {$i < 5} {incr i} {
	lassign [determineClusters $n $n 0.5] nC
	incr tot $nC
    }
    puts "n=$n, K(p)=[expr {$tot/5.0/$n**2}]"
}
