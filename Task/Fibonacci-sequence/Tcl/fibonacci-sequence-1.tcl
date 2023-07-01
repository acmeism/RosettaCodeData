proc fibiter n {
    if {$n < 2} {return $n}
    set prev 1
    set fib 1
    for {set i 2} {$i < $n} {incr i} {
        lassign [list $fib [incr fib $prev]] prev fib
    }
    return $fib
}
