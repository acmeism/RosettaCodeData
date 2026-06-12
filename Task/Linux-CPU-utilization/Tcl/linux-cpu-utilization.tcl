# forgive the pun!
proc stat {} {

    set fd [open /proc/stat r]
    set prevtotal 0
    set previdle 0

    while {1} {
        # read the first line of /proc/stat
        set line [gets $fd]
        seek $fd 0
        # discard the first word of that first line (it's always cpu)
        set line [lrange $line 1 end]
        # sum all of the times found on that first line to get the total time
        set total [::tcl::mathop::+ {*}$line]

        # parse each field out of line (we only need $idle)
        lassign $line user nice system idle iowait irq softirq steal guest guest_nice

        # update against previous measurement
        incr idle -$previdle
        incr total -$prevtotal
        incr previdle $idle
        incr prevtotal $total

        # divide the fourth column ("idle") by the total time, to get the fraction of time spent being idle
        set frac [expr {$idle * 1.0 / $total}]
        # subtract the previous fraction from 1.0 to get the time spent being not idle
        set frac [expr {1 - $frac}]
        # multiply by 100 to get a percentage
        set frac [expr {round($frac*100)}]

        if {[info coroutine] eq ""} {
            return $frac ;# if we're called outside a coroutine, return a number
        } else {
            puts [format CPU:%3d%% $frac]  ;# else print output
            yieldto after 1000 [info coroutine]
        }
    }
}

coroutine watchstat stat
