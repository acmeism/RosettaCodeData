proc sum {var lo hi term} {
    upvar 1 $var x
    set sum 0.0
    for {set x $lo} {$x < $hi} {incr x} {
        set sum [expr {$sum + [uplevel 1 [list expr $term]]}]
    }
    return $sum
}
puts [sum i 1 100 {1.0/$i}] ;# 5.177377517639621
