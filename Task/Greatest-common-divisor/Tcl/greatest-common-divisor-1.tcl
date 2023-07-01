package require Tcl 8.5
namespace path {::tcl::mathop ::tcl::mathfunc}
proc gcd_iter {p q} {
    while {$q != 0} {
        lassign [list $q [% $p $q]] p q
    }
    abs $p
}
