package require Tcl 8.5
set doors [lrepeat [expr {$n + 1}] closed]
for {set i 1} {$i <= sqrt($n)} {incr i} {
    lset doors [expr {$i ** 2}] open
}
for {set i 1} {$i <= $n} {incr i} {
    puts [format "door %d is %s" $i [lindex $doors $i]]
}
