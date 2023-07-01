proc fib {n} {
    if {$n < 2} then {expr {$n}} else {expr {[fib [expr {$n-1}]]+[fib [expr {$n-2}]]} }
}
