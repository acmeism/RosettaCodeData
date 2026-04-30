proc isprime n {
    set wheel {6 4 2 4 2 4 6 2}
    if {$n < 2} {
        return 0
    }

    if {$n % 2 == 0} {expr {$n == 2}} \
    elseif {$n % 3 == 0} {expr {$n == 3}} \
    elseif {$n % 5 == 0} {expr {$n == 5}} \
    else {
        set k 0
        set d 1
        while {true} {
            incr d [lindex $wheel $k]
            incr k
            if {$k == 8} {set k 0}

            if {$d*$d > $n} {
                return 1
            }
            if {$n % $d == 0} {
                return 0
            }
        }
    }
}

set primes {}

for {set i 1} {$i < 512} {incr i} {
    set d 1
    set n ""
    foreach b [split [format "%09b" $i] ""] {
        if {$b} {
            set n "$n$d"
        }
        incr d
    }
    if {[isprime $n]} {
        lappend primes $n
    }
}

set primes [lsort -integer $primes]
set k 0
foreach p $primes {
    puts -nonewline [format "%10i" $p]
    incr k
    if {$k == 8} {
        set k 0
        puts ""
    }
}

puts ""
