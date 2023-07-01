package require Tcl 8.5
namespace path {::tcl::mathop ::tcl::mathfunc}
proc gcd_bin {p q} {
    if {$p == $q} {return [abs $p]}
    set p [abs $p]
    if {$q == 0} {return $p}
    set q [abs $q]
    if {$p < $q} {lassign [list $q $p] p q}
    set k 1
    while {($p & 1) == 0 && ($q & 1) == 0} {
        set p [>> $p 1]
        set q [>> $q 1]
        set k [<< $k 1]
    }
    set t [expr {$p & 1 ? -$q : $p}]
    while {$t} {
        while {$t & 1 == 0} {set t [>> $t 1]}
        if {$t > 0} {set p $t} {set q [- $t]}
        set t [- $p $q]
    }
    return [* $p $k]
}
