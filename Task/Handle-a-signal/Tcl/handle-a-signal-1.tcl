package require Expect

proc sigint_handler {} {
    puts "elapsed time: [expr {[clock seconds] - $::start_time}] seconds"
    set ::looping false
}

trap sigint_handler SIGINT

set start_time [clock seconds]
set n 0
set looping true
while {$looping} {
    puts [incr n]
    after 500
}
