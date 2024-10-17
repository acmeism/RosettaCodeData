fn main() {
	
	let mut current_average:f32 = 0.0;
	let mut current_entry_number:u32 = 0;
	
	loop
	{
		let current_entry;

		println!("Enter rainfall int, 99999 to quit: ");
		let mut input_text = String::new();
		std::io::stdin().read_line(&mut input_text).expect("Failed to read from stdin");
		let trimmed = input_text.trim();
		match trimmed.parse::<u32>() {
			Ok(new_entry) => current_entry = new_entry,
			Err(..) => { println!("Invalid input"); continue; }
		};

		if current_entry == 99999
		{
			println!("User requested quit.");
			break;
		}
		else
		{
			current_entry_number = current_entry_number + 1;
			current_average = current_average + (1.0 / current_entry_number as f32)*(current_entry as f32) - (1.0 / current_entry_number as f32)*current_average;

			println!("New Average: {}", current_average);
		}
	}
}
