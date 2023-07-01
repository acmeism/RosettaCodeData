proc doit {{badx 250} {complete 0}} {
    ## NB: $badx is exclusive upper limit, and also limits y!
    for {set y 1} {$y < $badx} {incr y} {
        set s [expr {$y ** 5}]
        set r5($s) $y           ;# fifth roots of valid sums
    }
    for {set a 1} {$a < $badx} {incr a} {
        set suma [expr {$a ** 5}]
        for {set b 1} {$b <= $a} {incr b} {
            set sumb [expr {$suma + ($b ** 5)}]
            for {set c 1} {$c <= $b} {incr c} {
                set sumc [expr {$sumb + ($c ** 5)}]
                for {set d 1} {$d <= $c} {incr d} {
                    set sumd [expr {$sumc + ($d ** 5)}]
                    if {[info exists r5($sumd)]} {
                        set e $r5($sumd)
                        puts "$e^5 = $a^5 + $b^5 + $c^5 + $d^5"
                        if {!$complete} {
                            return
                        }
                    }
                }
            }
        }
    }
    puts "search complete (x < $badx)"
}
doit
