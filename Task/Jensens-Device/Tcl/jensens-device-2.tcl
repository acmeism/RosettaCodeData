proc sum2 {lo hi lambda} {
    set sum 0.0
    for {set n $lo} {$n < $hi} {incr n} {
        set sum [expr {$sum + [apply $lambda $n]}]
    }
    return $sum
}
puts [sum2 1 100 {i {expr {1.0/$i}}}] ;# 5.177377517639621
