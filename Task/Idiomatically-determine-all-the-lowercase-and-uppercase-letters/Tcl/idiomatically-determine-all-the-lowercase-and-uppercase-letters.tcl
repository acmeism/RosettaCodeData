for {set c 0} {$c <= 0xffff} {incr c} {
    set ch [format "%c" $c]
    if {[string is upper $ch]} {lappend upper $ch}
    if {[string is lower $ch]} {lappend lower $ch}
}
puts "Upper: $upper"
puts "Lower: $lower"
