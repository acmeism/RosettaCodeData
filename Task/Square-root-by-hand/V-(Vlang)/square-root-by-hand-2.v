import math
import gmp
import strings

fn sqrt(n f64, limit int) string {
	one := gmp.from_i64(1)
	ten := gmp.from_i64(10)
	twenty := gmp.from_i64(20)
	hundred := gmp.from_i64(100)

	mut n0 := f64(n)
	if n0 < 0 {
		panic('Number cannot be negative')
	}
	mut count := 0
	for n0 != math.trunc(n0) {
		n0 *= 100
		count--
	}
	mut i := gmp.from_f64(n0)
	mut j := i.isqrt()
	count += j.str().len
	mut k := j.clone()
	mut d := j.clone()
	mut digits := 0
	mut root := ''
	for digits < limit {
		root += d.str()
		i = (i - k * d) * hundred
		k = j * twenty
		d = one.clone()
		for gmp.cmp(d, ten) <= 0 {
			if gmp.cmp((k + d) * d, i) > 0 {
				d.dec()
				break
			}
			d.inc()
		}
		j = j * ten + d
		k = k + d
		digits++
	}

	root = root.trim_right('0')
	if root.len == 0 {
		root = '0'
	}
	if count > 0 {
		root = root[0..count] + '.' + root[count..]
	} else if count == 0 {
		root = '0.' + root
	} else {
		root = '0.' + strings.repeat(`0`, -count) + root
	}
	root = root.trim_right('.')
	return root
}

fn main() {
	numbers := [f64(2), 0.2, 10.89, 625, 0.0001]
	digits := [500, 80, 8, 8, 8]
	for i, n in numbers {
		println('First ${digits[i]} significant digits (at most) of the square root of $n:')
		println(sqrt(n, digits[i]))
	}
}
