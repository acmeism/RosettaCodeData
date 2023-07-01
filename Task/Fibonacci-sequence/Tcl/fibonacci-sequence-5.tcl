proc fib-tailrec {n} {
    proc fib:inner {a b n} {
        if {$n < 1} {
            return $a
        } elseif {$n == 1} {
            return $b
        } else {
            tailcall fib:inner $b [expr {$a + $b}] [expr {$n - 1}]
        }
    }
    return [fib:inner 0 1 $n]
}
