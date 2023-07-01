package require Tcl 8.5
namespace path ::tcl::mathfunc

proc size {m} {
    set rows [llength $m]
    set cols [llength [lindex $m 0]]
    return [list $rows $cols]
}
proc transpose {m} {
    lassign [size $m] rows cols
    set new [lrepeat $cols [lrepeat $rows ""]]
    for {set i 0} {$i < $rows} {incr i} {
        for {set j 0} {$j < $cols} {incr j} {
            lset new $j $i [lindex $m $i $j]
        }
    }
    return $new
}
proc print_matrix {m {fmt "%.17g"}} {
    set max [widest $m $fmt]
    lassign [size $m] rows cols
    for {set i 0} {$i < $rows} {incr i} {
        for {set j 0} {$j < $cols} {incr j} {
	    set s [format $fmt [lindex $m $i $j]]
            puts -nonewline [format "%*s " [lindex $max $j] $s]
        }
        puts ""
    }
}
proc widest {m {fmt "%.17g"}} {
    lassign [size $m] rows cols
    set max [lrepeat $cols 0]
    for {set i 0} {$i < $rows} {incr i} {
        for {set j 0} {$j < $cols} {incr j} {
	    set s [format $fmt [lindex $m $i $j]]
            lset max $j [max [lindex $max $j] [string length $s]]
        }
    }
    return $max
}

set m {{1 1 1 1} {2 4 8 16} {3 9 27 81} {4 16 64 256} {5 25 125 625}}
print_matrix $m "%d"
print_matrix [transpose $m] "%d"
