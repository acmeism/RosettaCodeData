## Mathematically, the first term has index "0", not "1".  We do that, also.

set ::vE 0

proc vanEck {n} {
    global vE vEocc
    while {$n >= [set k [expr {[llength $vE] - 1}]]} {
        set kv [lindex $vE $k]
        ## value $kv @ $k is not yet stuffed into vEocc()
        lappend vE [expr {[info exists vEocc($kv)] ? $k - $vEocc($kv) : 0}]
        set vEocc($kv) $k
    }
    return [lindex $vE $n]
}

proc show {func from to} {
    for {set n $from} {$n <= $to} {incr n} {
        append r " " [$func $n]
    }
    puts "${func}($from..$to) =$r"
}

show vanEck 0 9
show vanEck 990 999
