struct Params {
	a int
	b int
	c int
}

fn a_fn(p Params) int {
    return p.a + p.b + p.c
}

fn main() {
    x := a_fn(Params{a: 1, b: 2, c: 3}) // same order
    println("x = ${x}")
    y := a_fn(Params{c: 3, b: 2, a: 1}) // different order
    println("y = ${y}")
    z := a_fn(Params{c: 2})             // only one field
    println("z = ${z}")
	
}
