proc ProperDivisors {n} {
    if {$n == 1} {return 0}
    set divs 1
    set sum 1
    for {set i 2} {$i*$i <= $n} {incr i} {
        if {! ($n % $i)} {
            lappend divs $i
            incr sum $i
            if {$i*$i<$n} {
                lappend divs [set d [expr {$n / $i}]]
                incr sum $d
            }
        }
    }
    list $sum $divs
}

proc al_iter {n} {
    yield [info coroutine]
    while {$n} {
        yield $n
        lassign [ProperDivisors $n] n
    }
    yield 0
    return -code break
}

proc al_classify {n} {
    coroutine iter al_iter $n
    set items {}
    try {
        set type "non-terminating"
        while {[llength $items] < 16} {
            set i [iter]
            if {$i == 0} {
                set type "terminating"
            }
            set ix [lsearch -exact $items $i]
            set items [linsert $items 0 $i]
            switch $ix {
                -1 { continue }
                0 { throw RESULT "perfect" }
                1 { throw RESULT "amicable" }
                default { throw RESULT "sociable" }
            }
        }
    } trap {RESULT} {type} {
        rename iter {}
        set map {
            perfect aspiring
            amicable cyclic
            sociable cyclic
        }
        if {$ix != [llength $items]-2} {
            set type [dict get $map $type]
        }
    }
    list $type [lreverse $items]
}

for {set i 1} {$i <= 10} {incr i} {
    puts [format "%8d -> %-16s : %s" $i {*}[al_classify $i]]
}

foreach i {11 12 28 496 220 1184 12496 1264460 790 909 562 1064 1488 } {
    puts [format "%8d -> %-16s : %s" $i {*}[al_classify $i]]
}

;# stretch goal .. let's time it:
set i 15355717786080
puts [time {
    puts [format "%8d -> %-16s : %s" $i {*}[al_classify $i]]
}]
