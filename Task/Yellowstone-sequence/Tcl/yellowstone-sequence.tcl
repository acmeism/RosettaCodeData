proc gcd {a b} {
    while {$b} {
        lassign [list $b [expr {$a % $b}]] a b
    }
    return $a
}

proc gen_yellowstones {{maxN 30}} {
    set r {}
    for {set n 1} {$n <= $maxN} {incr n} {
        if {$n <= 3} {
            lappend r $n
        } else {
            ## NB: list indices start at 0, not 1.
            set pred    [lindex $r end  ]       ;# a(n-1): coprime
            set prepred [lindex $r end-1]       ;# a(n-2): not coprime
            for {set k 4} {1} {incr k} {
                if {[lsearch -exact $r $k] >= 0} { continue }
                if {1 != [gcd $k $pred   ]} { continue }
                if {1 == [gcd $k $prepred]} { continue }
                ## candidate k survived all tests...
                break
            }
            lappend r $k
        }
    }
    return $r
}
puts "The first 30 Yellowstone numbers are:"
puts [gen_yellowstones]
