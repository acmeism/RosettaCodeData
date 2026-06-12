#[link(name = "scriptedmain")];

use std;

fn meaning_of_life() -> int {
	ret 42;
}

fn main() {
	std::io::println("Main: The meaning of life is " + core::int::to_str(meaning_of_life(), 10u));
}
