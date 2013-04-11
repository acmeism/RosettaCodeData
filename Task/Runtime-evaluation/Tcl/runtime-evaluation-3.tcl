set i [interp create]
interp limit $i commands -value [expr [$i eval info cmdcount]+20] -granularity 1
interp eval $i {
    set x 0
    while {1} { # Infinite loop! Bwahahahaha!
        puts "Counting up... [incr x]"
    }
}
