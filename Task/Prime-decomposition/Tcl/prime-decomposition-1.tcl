proc factors {x} {
    # list the prime factors of x in ascending order
    set result [list]
    while {$x % 2 == 0} {
        lappend result 2
        set x [expr {$x / 2}]
    }
    for {set i 3} {$i*$i <= $x} {incr i 2} {
        while {$x % $i == 0} {
            lappend result $i
            set x [expr {$x / $i}]
        }
    }
    if {$x != 1} {lappend result $x}
    return $result
}
