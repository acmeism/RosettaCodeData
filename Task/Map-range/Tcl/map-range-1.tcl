package require Tcl 8.5
proc rangemap {rangeA rangeB value} {
    lassign $rangeA a1 a2
    lassign $rangeB b1 b2
    expr {$b1 + ($value - $a1)*double($b2 - $b1)/($a2 - $a1)}
}
