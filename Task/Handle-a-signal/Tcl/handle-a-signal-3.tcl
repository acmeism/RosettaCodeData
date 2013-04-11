package require Tclx

signal error sigint

set start_time [clock seconds]
set n 0
proc infinite_loop {} {
    while 1 {
        puts [incr n]
        after 500
    }
}
if {[catch infinite_loop out] != 0} {
    lassign $::errorCode class name msg
    if {$class eq "POSIX" && $name eq "SIG" && $msg eq "SIGINT"} {
        puts "elapsed time: [expr {[clock seconds] - $start_time}] seconds"
    } else {
        puts "infinite loop interrupted, but not on SIGINT: $::errorInfo"
    }
}
