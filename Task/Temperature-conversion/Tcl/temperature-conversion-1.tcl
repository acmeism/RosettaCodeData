proc temps {k} {
    set c [expr {$k - 273.15}]
    set r [expr {$k / 5.0 * 9.0}]
    set f [expr {$r - 459.67}]
    list $k $c $f $r
}
