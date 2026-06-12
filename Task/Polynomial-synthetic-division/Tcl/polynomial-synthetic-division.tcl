#   range ?start? end+1
# start defaults to 0:  [range 5] = {0 1 2 3 4}
proc range {a {b ""}} {
    if {$b eq ""} {
        set b $a
        set a 0
    }
    for {set r {}} {$a<$b} {incr a} {
        lappend r $a
    }
    return $r
}

#   lincr list idx ?...? increment
# By analogy with [lset] and [incr]:
# Adds incr to the item at [lindex list idx ?...?].  incr may be a float.
proc lincr {_ls args} {
    upvar 1 $_ls ls
    set incr [lindex $args end]
    set idxs [lrange $args 0 end-1]
    lset ls {*}$idxs [expr {$incr + [lindex $ls {*}$idxs]}]
}

namespace eval polynomial {
    # polynomial division, returns [list $dividend $remainder]
    proc divide {top btm} {
        set out $top
        set norm [lindex $btm 0]
        foreach i [range [expr {[llength $top] - [llength $btm] + 1}]] {
            lset out $i [set coef [expr {[lindex $out $i] * 1.0 / $norm}]]
            if {$coef != 0} {
                foreach j [range 1 [llength $btm]] {
                    lincr out [expr {$i+$j}] [expr {-[lindex $btm $j] * $coef}]
                }
            }
        }
        set terms [expr {[llength $btm]-1}]
        list [lrange $out 0 end-$terms] [lrange $out end-[incr terms -1] end]
    }
    namespace export *
    namespace ensemble create
}

proc test {} {
    set top {1 -12 0 -42}
    set btm {1 -3}
    set div [polynomial divide $top $btm]
    puts "$top / $btm = $div"
}
test
