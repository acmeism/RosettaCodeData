proc catalan n {
    set result {}
    array set t {0 0 1 1}
    for {set i 1} {[set k $i] <= $n} {incr i} {
	for {set j $i} {$j > 1} {} {incr t($j) $t([incr j -1])}
	set t([incr k]) $t($i)
	for {set j $k} {$j > 1} {} {incr t($j) $t([incr j -1])}
	lappend result [expr {$t($k) - $t($i)}]
    }
    return $result
}

puts [catalan 15]
