for {set i 0} {$i < 15} {incr i} {
    puts "C_$i = [expr {catalan($i)}]"
}
