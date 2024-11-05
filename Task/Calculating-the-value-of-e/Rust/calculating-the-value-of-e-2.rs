fn spigot(a: &mut Vec<u32>) -> u32 {
	a.iter_mut().enumerate().rfold(0,|q, (idx, ai)|{
		let ai1 = *ai * 10 + q;
		let idx1 = 2 + idx as u32;
		*ai = ai1 % idx1;
		ai1 / idx1
	})
}

fn spigot_loop(num: u32) {
	let line_len = 80;
	let mut arr = vec!(1u32; 1 + num as usize);
	print!("2.");
	for count in 3..num + 3 {
		print!("{}", spigot(&mut arr));
		if count % line_len == 0 || count == num + 2 {println!()};
	}
}

fn default() -> u32 {
	println!("invalid param - use default");
	500
}

fn main() {
	let args: Vec<String> = std::env::args().collect();
	let num_digits = match args.as_slice() {
		[_, arg1] => match arg1.parse::<u32>() {
					Ok(i) => i,
					Err(_) => default()
				},
		_ => default()
	};

	spigot_loop(num_digits);
}
