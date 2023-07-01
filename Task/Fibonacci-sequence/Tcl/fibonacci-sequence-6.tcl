proc fibiter n {
    if {$n < 0} {
        set n [expr {abs($n)}]
        set sign [expr {-1**($n+1)}]
    } else {
        set sign 1
    }
    if {$n < 2} {return $n}
    set prev 1
    set fib 1
    for {set i 2} {$i < $n} {incr i} {
        lassign [list $fib [incr fib $prev]] prev fib
    }
    return [expr {$sign * $fib}]
}
fibiter -5 ;# ==> 5
fibiter -6 ;# ==> -8
