// Only valid for n > 0 && base >= 2
fn mult(nn u64, base int) u64 {
	mut n := nn
	mut mult := u64(0)
	for mult = 1; mult > 0 && n > 0; n /= u64(base) {
		mult *= n % u64(base)
	}
	return mult
}

// Only valid for n >= 0 && base >= 2
fn multi_digital_root(n u64, base int) (int, int) {
	mut m := u64(0)
	mut mp := 0
	for m = n; m >= u64(base); mp++ {
		m = mult(m, base)
	}
	return mp, int(m)
}
const base = 10

fn main() {
	size := 5

	println("${'Number':20} ${'MDR':3} ${'MP':3}")
	for n in [
		u64(123321), 7739, 893, 899998,
		18446743999999999999,
		// From http://mathworld.wolfram.com/MultiplicativePersistence.html
		3778888999, 277777788888899,
	 ] {
		mp, mdr := multi_digital_root(n, base)
		println("${n:20} ${mdr:3} ${mp:3}")
	}
	println('')

	mut list := [base][]u64{init: []u64{len: 0, cap:size}}
	for cnt, n := size*base, u64(0); cnt > 0; n++ {
		_, mdr := multi_digital_root(n, base)
		if list[mdr].len < size {
			list[mdr] << n
			cnt--
		}
	}
	println("${'MDR':3}: First")
	for i, l in list {
		println("${i:3}: $l")
	}
}
