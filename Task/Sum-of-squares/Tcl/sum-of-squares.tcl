package require Tcl 8.6
namespace path ::tcl::mathop

# {*} is like apply in Scheme--it turns a list into multiple arguments
proc sum_of_squares lst {
    + {*}[lmap x $lst {* $x $x}]
}
puts [sum_of_squares {1 2 3 4}]; # ==> 30
puts [sum_of_squares {}];        # ==> 0
