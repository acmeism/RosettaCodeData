proc isPrime {n} {
    if {$n < 2} {
        return 0
    }
    if {$n > 3} {
        if {0 == ($n % 2)} {
            return 0
        }
        for {set d 3} {($d * $d) <= $n} {incr d 2} {
            if {0 == ($n % $d)} {
                return 0
            }
        }
    }
    return 1                    ;# no divisor found
}

proc cntPF {n} {
    set cnt 0
    while {0 == ($n % 2)} {
        set n [expr {$n / 2}]
        incr cnt
    }
    for {set d 3} {($d * $d) <= $n} {incr d 2} {
        while {0 == ($n % $d)} {
            set n [expr {$n / $d}]
            incr cnt
        }
    }
    if {$n > 1} {
        incr cnt
    }
    return $cnt
}

proc showRange {lo hi} {
    puts "Attractive numbers in range $lo..$hi are:"
    set k 0
    for {set n $lo} {$n <= $hi} {incr n} {
        if {[isPrime [cntPF $n]]} {
            puts -nonewline " [format %3s $n]"
            incr k
        }
        if {$k >= 20} {
            puts ""
            set k 0
        }
    }
    if {$k > 0} {
        puts ""
    }
}
showRange 1 120
