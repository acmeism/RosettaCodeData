fn main() {
	println("42 %! 2017 = ${mult_inv(42, 2017)}")
}

fn mult_inv(aa int, bb int) int {
	mut a, mut b := aa, bb
	mut x0, mut t := 0, 0
	mut b0 := b
	mut x1 := 1
	if b == 1 {return 1}
	for a > 1 {
		q := a / b
		t = b
		b = a % b
		a = t
		t = x0
		x0 = x1 - q * x0
		x1 = t
	}
	if x1 < 0 {x1 += b0}
	return x1
}
