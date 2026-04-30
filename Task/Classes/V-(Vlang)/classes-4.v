// all fields below 'pub mut:' would be public and mutable, while those above it, would not

pub struct Public {
	data_1 string = "Hello" // other modules can not change
	pub mut:
	data_2 string // other modules can change
	data_3 string // other modules can change
}

struct Private {
	data string
}

pub fn public_function() {}

fn private_function() {}

// '@[noinit]'

module sample

@[noinit]
pub struct Information {
	pub:
	data string = "Mike"
}

// factory function

pub fn new_information(data string) !Information {
	if data.len == 0 || data.len > 100 {
		return error("data must be between 1 and 100 characters")
	}
	return Information{
		data: data
	}
}
