proc tm_expand {s} {string map {0 01 1 10} $s}
# this could also be written as:
# interp alias {} tm_expand {} string map {0 01 1 10}

proc tm {k} {
    set s 0
    while {[incr k -1] >= 0} {
        set s [tm_expand $s]
    }
    return $s
}
