fn multifactorial(n: i32, deg: i32) -> i32 {
	if n < 1 {
		1
	} else {
		n * multifactorial(n - deg, deg)
	}
}

fn main() {
	for i in 1..6 {
		for j in 1..11 {
			print!("{} ", multifactorial(j, i));
		}
	println!("");
	}
}
