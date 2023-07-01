set iters 10

# A silly example task
proc theTask {} {
    for {set a 0} {$a < 100000} {incr a} {
        expr {$a**3+$a**2+$a+1}
    }
}

# Measure the time taken $iters times
for {set i 1} {$i <= $iters} {incr i} {
    set t [lindex [time {
        theTask
    }] 0]
    puts "task took $t microseconds on iteration $i"
}
