package require Tcl 8.5
namespace import ::tcl::mathop::+
namespace import ::tcl::mathop::-
namespace import ::tcl::mathfunc::max

proc d_lcs {a b} {
    set la [string length $a]
    set lb [string length $b]
    set lengths [lrepeat [+ $la 1] [lrepeat [+ $lb 1] 0]]

    for {set i 0} {$i < $la} {incr i} {
        for {set j 0} {$j < $lb} {incr j} {
            if {[string index $a $i] eq [string index $b $j]} {
                lset lengths [+ $i 1] [+ $j 1] [+ [lindex $lengths $i $j] 1]
            } else {
                lset lengths [+ $i 1] [+ $j 1] [max [lindex $lengths [+ $i 1] $j] [lindex $lengths $i [+ $j 1]]]
            }
        }
    }

    set result ""
    set x $la
    set y $lb
    while {$x > 0 && $y > 0} {
        if {[lindex $lengths $x $y] == [lindex $lengths [- $x 1] $y]} {
            incr x -1
        } elseif {[lindex $lengths $x $y] == [lindex $lengths $x [- $y 1]]} {
            incr y -1
        } else {
            if {[set c [string index $a [- $x 1]]] ne [string index $b [- $y 1]]} {
                error "assertion failed: a.charAt(x-1) == b.charAt(y-1)"
            }
            append result $c
            incr x -1
            incr y -1
        }
    }
    return [string reverse $result]
}
