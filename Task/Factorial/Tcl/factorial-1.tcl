proc ifact n {
    for {set i $n; set sum 1} {$i >= 2} {incr i -1} {
        set sum [expr {$sum * $i}]
    }
    return $sum
}
