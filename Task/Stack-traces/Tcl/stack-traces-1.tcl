proc printStackTrace {} {
    puts "Stack trace:"
    for {set i 1} {$i < [info level]} {incr i} {
        puts [string repeat "  " $i][info level $i]
    }
}
