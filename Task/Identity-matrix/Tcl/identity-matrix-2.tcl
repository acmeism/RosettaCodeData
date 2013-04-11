package require struct::matrix

proc I {rank {zero 0.0} {one 1.0}} {
    set m [struct::matrix]
    $m add columns $rank
    $m add rows $rank
    for {set i 0} {$i < $rank} {incr i} {
	for {set j 0} {$j < $rank} {incr j} {
	    $m set cell $i $j [expr {$i==$j ? $one : $zero}]
	}
    }
    return $m
}
