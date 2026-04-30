import math

// primality test
fn is_prime(nir i64) bool {
	mut ir := i64(0)
	if nir <= 1 { return false }
	if nir <= 3 { return true }
	if nir % 2 == 0 || nir % 3 == 0 { return false }
	ir = 5
	for ir * ir <= nir {
		if nir % ir == 0 || nir % (ir + 2) == 0 { return false }
		ir += 6
	}
	return true
}

fn jacobsthal(nir i64) i64 {
	return i64((math.exp2(f64(nir)) + (nir % 2))) / 3
	// or return ((i64(1) << nir) + (nir % 2)) / 3 // but might get compiler notice
}

fn jacobsthal_lucas(nir i64) i64 {
	mut sign := i64(1)
	if nir % 2 != 0 { sign = -1 } {return i64(math.exp2(f64(nir))) + sign}
	// or return (i64(1) << nir) + sign // but might get compiler notice
}

fn jacobsthal_oblong(nir i64) i64 {
	return jacobsthal(nir) * jacobsthal(nir + 1)
}

fn main() {
	println("First 30 Jacobsthal numbers:")
	mut jac_nums, mut jac_lucas_nums := []i64{}, []i64{}
	mut jac_oblong_nums, mut prime_jac := []i64{}, []i64{}
	mut ir := i64(0)
	for val in i64(0) .. i64(30) {
		jac_nums << jacobsthal(val)
	}
	println(jac_nums.str())
	println("\nFirst 30 Jacobsthal-Lucas numbers:")
	for val in i64(0) .. i64(30) {
		jac_lucas_nums << jacobsthal_lucas(val)
	}
	println(jac_lucas_nums.str())
	println("\nFirst 20 Jacobsthal-Oblong numbers:")
	for val in i64(0) .. i64(20) {
		jac_oblong_nums << jacobsthal_oblong(val)
	}
	println(jac_oblong_nums.str())
	println("\nFirst 10 prime Jacobsthal numbers:")
	for prime_jac.len < 10 {
		jir := jacobsthal(ir)
		if is_prime(jir) { prime_jac << jir }
		ir++
	}
	println(prime_jac.str())
}
