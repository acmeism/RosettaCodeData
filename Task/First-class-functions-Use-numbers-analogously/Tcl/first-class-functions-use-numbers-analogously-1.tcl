package require Tcl 8.5
proc multiplier {a b} {
    list apply {{ab m} {expr {$ab*$m}}} [expr {$a*$b}]
}
