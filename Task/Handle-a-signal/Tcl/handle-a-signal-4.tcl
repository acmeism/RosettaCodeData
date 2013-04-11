package require Tclx

signal error sigint

set start_time [clock seconds]
proc infinite_loop {} {
    while 1 {
        puts [incr n]
        after 500
    }
}
try {
    infinite_loop
} trap {POSIX SIG SIGINT} {} {
    puts "elapsed time: [expr {[clock seconds] - $start_time}] seconds"
}
