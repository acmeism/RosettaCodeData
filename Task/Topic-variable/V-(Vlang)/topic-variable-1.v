// function that returns multiple values
fn foo() (int, int) {
	return 2, 3
}

mut a, mut b := foo()
println("${a} and ${b}")
a, _ = foo() // to ignore particular returned values, the `_` is used
println(a)
