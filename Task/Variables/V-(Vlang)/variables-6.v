fn main() {
	a := 10
	if true { a := 20 } // error: redefinition of `a`

	mut b := 20
	if true { b = 30 } // OK: `b` is mutable and used `=` to change value
}
