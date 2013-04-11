for {set i 0} {$i <= 20} {incr i} {
    puts [format "%2d:%9s" $i [zeckendorf $i]]
}
