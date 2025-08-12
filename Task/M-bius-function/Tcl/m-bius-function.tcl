proc prime_factors {n} {
    set d 1
    set factors [list]
    while {$n > 1 && $d < $n} {
        incr d
        set d_squared [expr {$d * $d}]
        while {$n % $d == 0} {
            lappend factors $d
            set n [expr {$n / $d}]
        }
    }
    return $factors
}

proc mobius {n} {
    set p [prime_factors $n]
    set unique_p [lsort -unique $p]
    if {[llength $p] == [llength $unique_p]} {
        if {[llength $p] % 2 == 0} {
            return 1
        } else {
            return -1
        }
    } else {
        return 0
    }
}

set upto 199
set moebius_sequence [list]
for {set i 1} {$i <= $upto} {incr i} {
    lappend moebius_sequence [mobius $i]
}

puts "Möbius sequence - First $upto terms:"
for {set i 0} {$i < $upto} {incr i} {
    if {$i % 20 == 0 && $i != 0} {
        puts ""
    }
    puts -nonewline [format "%4d" [lindex $moebius_sequence $i]]
}
puts ""
