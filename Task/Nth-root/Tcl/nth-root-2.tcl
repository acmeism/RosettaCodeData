proc nthroot {n A} {
    set x0 [expr {$A / double($n)}]
    set m [expr {$n - 1.0}]
    while 1 {
        set x1 [expr {($m*$x0 + $A/$x0**$m) / $n}]
        if {abs($x1 - $x0) < abs($x0 * 1e-9)} {
            return $x1
        }
        set x0 $x1
    }
}
