foreach w [read [open unixdict.txt]] {
    if {[string first the $w] != -1 && [string length $w] > 11} {
        puts $w
    }
}
