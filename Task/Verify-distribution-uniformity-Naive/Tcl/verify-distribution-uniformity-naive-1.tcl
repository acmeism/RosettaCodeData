proc distcheck {random times {delta 1}} {
    for {set i 0} {$i<$times} {incr i} {incr vals([uplevel 1 $random])}
    set target [expr {$times / [array size vals]}]
    foreach {k v} [array get vals] {
        if {abs($v - $target) > $times  * $delta / 100.0} {
           error "distribution potentially skewed for $k: expected around $target, got $v"
        }
    }
    foreach k [lsort -integer [array names vals]] {lappend result $k $vals($k)}
    return $result
}
