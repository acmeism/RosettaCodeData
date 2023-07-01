proc format_%t {n} {
    while {$n} {
        append r [expr {$n % 3}]
        set n [expr {$n / 3}]
    }
    if {![info exists r]} {set r 0}
    string reverse $r
}
