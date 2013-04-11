def y := fn f { fn x { x(x) }(fn y { f(fn a { y(y)(a) }) }) }
def fac := fn f { fn n { if (n<2) {1} else { n*f(n-1) } }}
def fib := fn f { fn n { if (n == 0) {0} else if (n == 1) {1} else { f(n-1) + f(n-2) } }}
