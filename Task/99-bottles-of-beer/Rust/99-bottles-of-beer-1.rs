fn main() {
	for n in (0..100).rev() {
		match n {
			0 => {
				println!("No more bottles of beer on the wall, no more bottles of beer.");
				println!("Go to the store and buy some more, 99 bottles of beer on the wall.");
			},
			1 => {
				println!("1 bottle of beer on the wall, 1 bottle of beer.");
				println!("Take one down and pass it around, no more bottles of beer on the wall.\n");
			},
			_ => {
				println!("{0:?} bottles of beer on the wall, {0:?} bottles of beer.", n);
				println!("Take one down and pass it around, {} bottles of beer on the wall.\n", n-1);
			},
		}
	}
}
