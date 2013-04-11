proc sumOfSquares {nums} {
    set sum 0
    foreach num $nums {
        set sum [expr {$sum + $num**2}]
    }
    return $sum
}
sumOfSquares {1 2 3 4 5} ;# ==> 55
sumOfSquares {} ;# ==> 0
