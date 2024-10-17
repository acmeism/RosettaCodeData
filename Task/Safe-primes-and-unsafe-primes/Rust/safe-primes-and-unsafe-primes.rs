fn is_prime(n: i32) -> bool {
	for i in 2..n {
		if i * i > n {
			return true;
		}
		if n % i == 0 {
			return false;
		}
	}
	n > 1
}

fn is_safe_prime(n: i32) -> bool {
	is_prime(n) && is_prime((n - 1) / 2)
}

fn is_unsafe_prime(n: i32) -> bool {
	is_prime(n) && !is_prime((n - 1) / 2)
}

fn next_prime(n: i32) -> i32 {
	for i in (n+1).. {
		if is_prime(i) {
			return i;
		}
	}
	0
}

fn main() {
	let mut safe = 0;
	let mut unsf = 0;
	let mut p = 2;

	print!("first 35 safe primes: ");
	while safe < 35 {
		if is_safe_prime(p) {
			safe += 1;
			print!("{} ", p);
		}
		p = next_prime(p);
	}
	println!("");

	p = 2;

	print!("first 35 unsafe primes: ");
	while unsf < 35 {
		if is_unsafe_prime(p) {
			unsf += 1;
			print!("{} ", p);
		}
		p = next_prime(p);
	}
	println!("");

	p = 2;
	safe = 0;
	unsf = 0;

	while p < 1000000 {
		if is_safe_prime(p) {
			safe += 1;
		} else {
			unsf += 1;
		}
		p = next_prime(p);
	}
	println!("safe primes below 1,000,000: {}", safe);
	println!("unsafe primes below 1,000,000: {}", unsf);

	while p < 10000000 {
		if is_safe_prime(p) {
			safe += 1;
		} else {
			unsf += 1;
		}
		p = next_prime(p);
	}
	println!("safe primes below 10,000,000: {}", safe);
	println!("unsafe primes below 10,000,000: {}", unsf);
}
