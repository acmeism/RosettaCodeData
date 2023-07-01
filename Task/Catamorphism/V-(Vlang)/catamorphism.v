fn main() {
	n := [1, 2, 3, 4, 5]

	println(reduce(add, n))
	println(reduce(sub, n))
	println(reduce(mul, n))
}

fn add(a int, b int) int { return a + b }
fn sub(a int, b int) int { return a - b }
fn mul(a int, b int) int { return a * b }

fn reduce(rf fn(int, int) int, m []int) int {
	mut r := m[0]
	for  v in m[1..] {
		r = rf(r, v)
	}
	return r
}
