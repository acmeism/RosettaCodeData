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

fn next_prime(n: i32) -> i32 {
	for i in (n+1).. {
		if is_prime(i) {
			return i;
		}
	}
	0
}

fn main() {
	let mut n = 0;
	let mut prime_q = 5;
	let mut prime_p = 3;
	let mut prime_o = 2;

	print!("First 36 strong primes: ");
	while n < 36 {
		if prime_p > (prime_o + prime_q) / 2 {
			print!("{} ",prime_p);
			n += 1;
		}
		prime_o = prime_p;
		prime_p = prime_q;
		prime_q = next_prime(prime_q);
	}
	println!("");

	while prime_p < 1000000 {
		if prime_p > (prime_o + prime_q) / 2 {
			n += 1;
		}
		prime_o = prime_p;
		prime_p = prime_q;
		prime_q = next_prime(prime_q);
	}
	println!("strong primes below 1,000,000: {}", n);

	while prime_p < 10000000 {
		if prime_p > (prime_o + prime_q) / 2 {
			n += 1;
		}
		prime_o = prime_p;
		prime_p = prime_q;
		prime_q = next_prime(prime_q);
	}
	println!("strong primes below 10,000,000: {}", n);

	n = 0;
	prime_q = 5;
	prime_p = 3;
	prime_o = 2;

	print!("First 36 weak primes: ");
	while n < 36 {
		if prime_p < (prime_o + prime_q) / 2 {
			print!("{} ",prime_p);
			n += 1;
		}
		prime_o = prime_p;
		prime_p = prime_q;
		prime_q = next_prime(prime_q);
	}
	println!("");

	while prime_p < 1000000 {
		if prime_p < (prime_o + prime_q) / 2 {
			n += 1;
		}
		prime_o = prime_p;
		prime_p = prime_q;
		prime_q = next_prime(prime_q);
	}
	println!("weak primes below 1,000,000: {}", n);

	while prime_p < 10000000 {
		if prime_p < (prime_o + prime_q) / 2 {
			n += 1;
		}
		prime_o = prime_p;
		prime_p = prime_q;
		prime_q = next_prime(prime_q);
	}
	println!("weak primes below 10,000,000: {}", n);
}
