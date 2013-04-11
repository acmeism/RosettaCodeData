package require Tcl 8.5
package require struct::list

proc sum_of {lambda nums} {
    struct::list fold [struct::list map $nums [list apply $lambda]] 0 ::tcl::mathop::+
}

sum_of $S [range 1 1001] ;# ==> 1.6439345666815615
