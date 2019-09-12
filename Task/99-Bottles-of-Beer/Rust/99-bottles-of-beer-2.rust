trait Bottles {
	fn bottles_of_beer(&self) -> Self;
	fn on_the_wall(&self);
}

impl Bottles for u32 {
	fn bottles_of_beer(&self) -> u32 {
		match *self {
			0 => print!("No bottles of beer"),
			1 => print!("{} bottle of beer", self),
			_ => print!("{} bottles of beer", self)
		}
		*self   // return a number for chaining
	}

	fn on_the_wall(&self) {
		println!(" on the wall!");
	}
}

fn main() {
	for i in (1..100).rev() {
		i.bottles_of_beer().on_the_wall();
		i.bottles_of_beer();
		println!("\nTake one down, pass it around...");
		(i - 1).bottles_of_beer().on_the_wall();
		println!("-----------------------------------");
	}
}
