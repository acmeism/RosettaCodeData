package require struct::list

proc square x {expr {$x * $x}}
proc + {a b} {expr {$a + $b}}
proc sumOfSquares {nums} {
    struct::list fold [struct::list map $nums square] 0 +
}
sumOfSquares {1 2 3 4 5} ;# ==> 55
sumOfSquares {} ;# ==> 0
