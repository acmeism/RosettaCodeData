for {set i 1; set end 10} true {incr i} {
    puts -nonewline $i
    if {$i >= $end} break
    puts -nonewline ", "
}
puts ""
