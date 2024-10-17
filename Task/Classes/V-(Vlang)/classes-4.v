// 'pub'

pub struct Public {
	pub:
	data string
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
	data string
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
