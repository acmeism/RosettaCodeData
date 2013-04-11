proc loopVar {var from lower to upper script} {
    if {$from ne "from" || $to ne "to"} {error "syntax error"}
    upvar 1 $var v
    if {$lower <= $upper} {
        for {set v $lower} {$v <= $upper} {incr v} {
            uplevel 1 $script
        }
    } else {
        # $upper and $lower really the other way round here
        for {set v $lower} {$v >= $upper} {incr v -1} {
            uplevel 1 $script
        }
    }
}
