package require Tcl 8.5
namespace path {::tcl::mathop ::tcl::} ;# Ease of access to mathop commands
proc lsum_series {l} {+ {*}[lmap n $l {/ [** $n 2]}]} ;# an expr would be clearer, but this is a demonstration of mathop

# using range function defined below
lsum_series [range 1 1001] ;# ==> 1.6439345666815615
