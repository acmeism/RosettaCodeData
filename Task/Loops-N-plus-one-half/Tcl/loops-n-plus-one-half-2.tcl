proc range {from to} {
    set result {}
    for {set i $from} {$i <= $to} {incr i} {
        lappend result $i
    }
    return $i
}

puts [join [range 1 10] ", "] ;# ==> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
