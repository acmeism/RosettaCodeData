namespace import ::tcl::mathop::-

proc subleq {pgm} {
    set ip 0
    while {$ip >= 0} {
        lassign [lrange $pgm $ip $ip+2] a b c
        incr ip 3
        if {$a == -1} {
            scan [read stdin 1] %C char
            lset pgm $b $char
        } elseif {$b == -1} {
            set char [format %c [lindex $pgm $a]]
            puts -nonewline $char
        } else {
            lset pgm $b [set res [- [lindex $pgm $b] [lindex $pgm $a]]]
            if {$res <= 0} {
                set ip $c
            }
        }
    }
}

fconfigure stdout -buffering none
subleq {15 17 -1 17 -1 -1 16 1 -1 16 3 -1 15 15 0 0 -1 72 101 108 108 111 44 32 119 111 114 108 100 33 10 0}
