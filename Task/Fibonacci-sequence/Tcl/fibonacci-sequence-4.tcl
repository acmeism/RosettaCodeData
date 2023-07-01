expr {fib(7)} ;# ==> 13

namespace path tcl::mathfunc #; or, interp alias {} fib {} tcl::mathfunc::fib
fib 7 ;# ==> 13
