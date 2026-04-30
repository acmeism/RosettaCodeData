@[params]
struct Params {
	a int // default value is 0
	b int
	c int = 20
}

fn a_fn(p Params) int {
    return p.a + p.b + p.c
}

fn b_fn(word string, num ?int) (string, int) {
	val := if num == none {0} else {num} // unwrap option type to assign value
	return word, val
}

fn main() {
    // using a struct as a parameter
    v := a_fn(Params{a: 1, b: 2, c: 3}) // same order, with new value given to `c`
    println("v = ${v}")
    w := a_fn(Params{c: 3, b: 2, a: 1}) // different order
    println("w = ${w}")
    x := a_fn(Params{c: 2}) // only one field
    println("x = ${x}")
	y := a_fn(Params{}) // no fields; given value of `c` and default values used
    println("y = ${y}")
    z := a_fn() // no parameters via @[params]; given value of `c` and default values used
    println("z = ${z}")
    // using an option type as a parameter
	println(b_fn('hello', 1000))
	println(b_fn('hello')) // no second parameter usage possible because option type (`?`)
}
