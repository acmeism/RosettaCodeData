proc ungap n {
    if {[string length $n] < 3} {
        return $n
    }
    return [string index $n 0][string index $n end]
}

proc gapful n {
    return [expr {0 == ($n % [ungap $n])}]
}

##      --> list of gapful numbers >= n
proc GFlist {count n} {
    set r {}
    while {[llength $r] < $count} {
        if {[gapful $n]} {
            lappend r $n
        }
        incr n
    }
    return $r
}

proc show {count n} {
    puts "The first $count gapful >= $n: [GFlist $count $n]"
}

show 30 100
show 15 1000000
show 10 1000000000
