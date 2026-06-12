proc MostFreqKSDF {inputStr1 inputStr2 k limit} {
    set c1 [set c2 {}]
    foreach ch [split $inputStr1 ""] {dict incr c1 $ch}
    foreach ch [split $inputStr2 ""] {dict incr c2 $ch}
    set c2 [lrange [lsort -stride 2 -index 1 -integer -decreasing $c2[set c2 {}]] 0 [expr {$k*2-1}]]
    set s 0
    foreach {ch n} [lrange [lsort -stride 2 -index 1 -integer -decreasing $c1[set c1 {}]] 0 [expr {$k*2-1}]] {
	if {[dict exists $c2 $ch]} {
	    incr s [expr {$n + [dict get $c2 $ch]}]
	}
    }
    return [expr {$limit - $s}]
}
