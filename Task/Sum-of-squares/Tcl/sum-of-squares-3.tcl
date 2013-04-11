package require Tcl 8.5
package require struct::list
namespace path ::tcl::mathop

proc sum_of {lambda nums} {
    struct::list fold [struct::list map $nums [list apply $lambda]] 0 +
}

sum_of {x {* $x $x}} {1 2 3 4 5} ;# ==> 55
