const val = 2 * 3 * 4 * 5 * 6 * 7 * 8 * 9 * 10

fn factorial[T](n T) T {
	$if T is $int {
		if n == 0 {return 1}
		else {return n * factorial(n - 1)}
	}
	return -1
}

fn main() {
	x := factorial(10)
	println("10! = ${x}")
	println("10! = ${val}")
}
