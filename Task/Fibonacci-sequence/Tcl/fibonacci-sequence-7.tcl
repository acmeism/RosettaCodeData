proc tcl::mathfunc::fib {n} {expr {$n<-1 ? -1**($n+1) * fib(abs($n)) : $n<2 ? $n : fib($n-1) + fib($n-2)}}
expr {fib(-5)} ;# ==> 5
expr {fib(-6)} ;# ==> -8
