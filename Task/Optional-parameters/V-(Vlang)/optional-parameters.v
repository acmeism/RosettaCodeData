struct Params {
	a int // default value is 0
	b int
	c int = 20
}

fn a_fn(p Params) int {
    return p.a + p.b + p.c
}

fn main() {
    w := a_fn(Params{a: 1, b: 2, c: 3}) // same order, with new value given to `c`
    println("w = ${w}")
    x := a_fn(Params{c: 3, b: 2, a: 1}) // different order
    println("x = ${x}")
    y := a_fn(Params{c: 2}) // only one field
    println("y = ${y}")
	z := a_fn(Params{}) // no fields, so given value of `c` and default values used
    println("z = ${z}")
}
