set amb {
    {the    that     a}
    {frog   elephant thing}
    {walked treaded  grows}
    {slowly quickly}
}

proc joins {a b} {
    expr {[string index $a end] eq [string index $b 0]}
}

foreach i [lindex $amb 0] {
    foreach j [lindex $amb 1] {
        if ![joins $i $j] continue
        foreach k [lindex $amb 2] {
            if ![joins $j $k] continue
            foreach l [lindex $amb 3] {
                if [joins $k $l] {
                    puts [list $i $j $k $l]
                }
            }
        }
    }
}
