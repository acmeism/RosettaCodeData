package require Tcl 8.5
set n 100
set doors [concat - [lrepeat $n 0]]
for {set step 1} {$step <= $n} {incr step} {
    for {set i $step} {$i <= $n} {incr i $step} {
        lset doors $i [expr { ! [lindex $doors $i]}]
    }
}
for {set i 1} {$i <= $n} {incr i} {
    puts [format "door %d is %s" $i [expr {[lindex $doors $i] ? "open" : "closed"}]]
}
