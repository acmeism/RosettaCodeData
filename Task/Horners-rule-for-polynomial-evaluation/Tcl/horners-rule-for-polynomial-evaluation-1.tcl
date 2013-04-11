package require Tcl 8.5
proc horner {coeffs x} {
    set y 0
    foreach c [lreverse $coeffs] {
        set y [expr { $y*$x+$c }]
    }
    return $y
}
