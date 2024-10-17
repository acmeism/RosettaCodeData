// returns the highest power of i that is a factor of n,
// and n divided by that power of i
fn factor_exponent(n: i32, i: i32) -> (i32, i32) {
	if n % i == 0 {
		let (a, b) = factor_exponent(n / i, i);
		(a + 1, b)
	} else {
		(0, n)
	}
}

fn tau(n: i32) -> i32 {
	for i in 2..(n+1) {
		if n % i == 0 {
			let (count, next) = factor_exponent(n, i);
			return (count + 1) * tau(next);
		}
	}
	return 1;
}

fn main() {
	for i in 1..101 {
		print!("{} ", tau(i));
	}
}
