enum Color as u8 {
	red
	green
	blue
}

// Reserved keywords may be escaped with an @.
enum Colors {
	@none
	red
	green
	blue
}

// Enums can be given explict integer values and converted into a string
enum Grocery {
	apple
	orange = 5
	pear
}

// Enums can have methods, just like structs
enum Cycle {
	one
	two
	three
}
fn (c Cycle) next() Cycle {
	match c {
		.one {
			return .two
		}
		.two {
			return .three
		}
		.three {
			return .one
		}
	}
}
