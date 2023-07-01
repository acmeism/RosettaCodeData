proc ifact_caching n {
    global fact_cache
    if { ! [info exists fact_cache]} {
        set fact_cache {1 1}
    }
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
