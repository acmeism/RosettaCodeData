proc check-cusip {code} {
    if {[string length $code] != 9} {
        return false
    }
    set alphabet 0123456789abcdefghijklmnopqrstuvwxyz@#
    set code [split [string tolower $code] ""]
    foreach char $code idx {1 2 3 4 5 6 7 8 9} {
        set v [string first $char $alphabet]
        if {$v == -1} {return false}
        if {$idx % 2 == 0} {
            incr v $v
        }
        set v [::tcl::mathop::+ {*}[split $v ""]]
        incr sum $v
    }
    expr {$sum % 10 == 0}
}
