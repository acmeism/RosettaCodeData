# a range command akin to Python's
proc range args {
    foreach {start stop step} [switch -exact -- [llength $args] {
        1 {concat 0 $args 1}
        2 {concat   $args 1}
        3 {concat   $args  }
        default {error {wrong # of args: should be "range ?start? stop ?step?"}}
    }] break
    if {$step == 0} {error "cannot create a range when step == 0"}
    set range [list]
    while {$step > 0 ? $start < $stop : $stop < $start} {
        lappend range $start
        incr start $step
    }
    return $range
}
