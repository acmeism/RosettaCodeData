proc fizzbuzz {n {m1 3} {m2 5}} {
    for {set i 1} {$i <= $n} {incr i} {
        set ans ""
        if {$i % $m1 == 0} {append ans Fizz}
        if {$i % $m2 == 0} {append ans Buzz}
        puts [expr {$ans eq "" ? $i : $ans}]
    }
}
fizzbuzz 100
