package require stepaway
proc safe+ {a b} {
    set val [expr {double($a) + $b}]
    return [list [stepdown $val] [stepup $val]]
}
