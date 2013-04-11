proc tcl::mathfunc::fib {n} {
    if { $n < 2 } {
        return $n
    } else {
        return [expr {fib($n-1) + fib($n-2)}]
    }
}

# or, more tersely

proc tcl::mathfunc::fib {n} {expr {$n<2 ? $n : fib($n-1) + fib($n-2)}}
