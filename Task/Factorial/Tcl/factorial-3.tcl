proc tcl::mathfunc::fact n {expr {$n < 2? 1: $n*fact($n-1)}}
