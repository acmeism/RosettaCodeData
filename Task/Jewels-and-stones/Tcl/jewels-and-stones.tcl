proc shavej {stones jewels} {
    set n 0
    foreach c [split $stones {}] {
        incr n [expr { [string first $c $jewels] >= 0 }]
    }
    return $n
}
puts [shavej aAAbbbb aA]
puts [shavej ZZ z]
