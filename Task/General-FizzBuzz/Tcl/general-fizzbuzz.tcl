proc fizzbuzz {n args} {
    if {$args eq ""} {
        set args {{3 Fizz} {5 Buzz}}
    }
    while {[incr i] <= $n} {
        set out ""
        foreach rule $args {
            lassign $rule m echo
            if {$i % $m == 0} {append out $echo}
        }
        if {$out eq ""} {set out $i}
        puts $out
    }
}
fizzbuzz 20 {3 Fizz} {5 Buzz} {7 Baxx}
