proc showNearest {heading tree point} {
    puts ${heading}:
    puts "Point:            \[[join $point ,]\]"
    lassign [$tree findNearest $point] nearest distance count
    puts "Nearest neighbor: \[[join $nearest ,]\]"
    puts "Distance:         $distance"
    puts "Nodes visited:    $count"
}
proc randomPoint k {
    for {set j 0} {$j < $k} {incr j} {lappend p [::tcl::mathfunc::rand]}
    return $p
}
proc randomPoints {k n} {
    for {set i 0} {$i < $n} {incr i} {
	set p {}
	for {set j 0} {$j < $k} {incr j} {
	    lappend p [::tcl::mathfunc::rand]
	}
	lappend ps $p
    }
    return $ps
}

KDTree create kd1 {{2 3} {5 4} {9 6} {4 7} {8 1} {7 2}}
showNearest "Wikipedia example data" kd1 {9 2}
puts ""

set N 1000
set t [time {KDTree create kd2 [randomPoints 3 $N]}]
showNearest "k-d tree with $N random 3D points (generation time: [lindex $t 0] us)" kd2 [randomPoint 3]
kd2 destroy
puts ""

set N 1000000
set t [time {KDTree create kd2 [randomPoints 3 $N]}]
showNearest "k-d tree with $N random 3D points (generation time: [lindex $t 0] us)" kd2 [randomPoint 3]
puts "Search time:      [time {kd2 findNearest [randomPoint 3]} 10000]"
