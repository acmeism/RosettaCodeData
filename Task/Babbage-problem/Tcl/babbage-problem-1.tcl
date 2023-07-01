for {set i 1} {![string match *269696 [expr $i*$i]]} {incr i} {}
puts "$i squared is [expr $i*$i]"
