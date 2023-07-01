for {set i 0} {$i < 16} {incr i} {
    for {set j $i} {$j < 128} {incr j 16} {
        if {$j <= 31} {
            continue                    ;# don't show values 0 - 31
        } elseif {$j ==  32} { set x "SP"
        } elseif {$j == 127} { set x "DEL"
        } else { set x [format %c $j] }
        puts -nonewline [format "%3d: %-5s" $j $x]
    }
    puts ""
}
