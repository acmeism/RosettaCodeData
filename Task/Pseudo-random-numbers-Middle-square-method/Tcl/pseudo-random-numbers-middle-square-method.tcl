set seed 675248

proc rnd {} {
    global seed
    set s [expr {$seed * $seed}]
    while {[string length $s] ne 12} {
        set s [string cat 0 $s]
    }
    set seed [string range $s 3 8]
    return $seed
}

for {set i 0} {$i < 5}  {incr i} {
    puts [rnd]
}
