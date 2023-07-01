proc repeat {command count} {
    for {set i 0} {$i < $count} {incr i} {
        uplevel 1 $command
    }
}

proc example {} {puts "This is an example"}
repeat example 4
