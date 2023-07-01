package require Tclx

proc sigint_handler {} {
    puts "elapsed time: [expr {[clock seconds] - $::start_time}] seconds"
    set ::looping false
}

signal trap sigint sigint_handler

set start_time [clock seconds]
set n 0
set looping true
while {$looping} {
    puts [incr n]
    after 500
}
