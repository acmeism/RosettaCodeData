mut a, mut b := foo()
println("${a} and ${b}")
a, _ = foo() // to ignore particular returned values, use `_`
println(a)
