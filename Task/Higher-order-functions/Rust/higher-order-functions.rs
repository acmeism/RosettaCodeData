fn execute_with_10<F: Fn(u64) -> u64> (f: F) -> u64 {
	f(10)
}

fn square(n: u64) -> u64 {
	n*n
}

fn main() {
	println!("{}", execute_with_10(|n| n*n )); // closure
	println!("{}", execute_with_10(square));   // function
}
