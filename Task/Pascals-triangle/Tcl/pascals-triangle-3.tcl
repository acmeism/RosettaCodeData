package require Tcl 8.5

proc pascal_combinations n {
    if {$n < 1} {error "undefined behaviour for n < 1"}
    for {set i 0} {$i < $n} {incr i} {
        set row [list]
        for {set j 0} {$j <= $i} {incr j} {
            lappend row [C $i $j]
        }
        lappend rows $row
    }
    return $rows
}

proc C {n k} {
    expr {[ifact $n] / ([ifact $k] * [ifact [expr {$n - $k}]])}
}

set fact_cache {1 1}
proc ifact n {
    global fact_cache
    if {$n < [llength $fact_cache]} {
        return [lindex $fact_cache $n]
    }
    set i [expr {[llength $fact_cache] - 1}]
    set sum [lindex $fact_cache $i]
    while {$i < $n} {
        incr i
        set sum [expr {$sum * $i}]
        lappend fact_cache $sum
    }
    return $sum
}

puts [join [pascal_combinations 6] \n]
