use std::env;
use std::process;
use std::collections::HashMap;

fn main() {

	let units: HashMap<&str, f32> = [("arshin",0.7112),("centimeter",0.01),("diuym",0.0254),("fut",0.3048),("kilometer",1000.0),("liniya",0.00254),("meter",1.0),("milia",7467.6),("piad",0.1778),("sazhen",2.1336),("tochka",0.000254),("vershok",0.04445),("versta",1066.8)].iter().cloned().collect();

	let args: Vec<String> = env::args().collect();
	if args.len() < 3 {
		eprintln!("A correct use is oldrus [amount] [unit].");
		process::exit(1);
	};

	let length_float;
	length_float = match args[1].parse::<f32>() {
		Ok(length_float) =>  length_float,
		Err(..) => 1 as f32,
	};

	let unit: &str = &args[2];
	if ! units.contains_key(unit) {
		let mut keys: Vec<&str> = Vec::new();
		for i in units.keys() {
			keys.push(i)
		};
		eprintln!("The correct units are: {}.", keys.join(", "));
		process::exit(1);
	};

	println!("{} {} to:", length_float, unit);
	for (lunit, length) in &units {
		println!("	{}: {:?}", lunit,  length_float * units.get(unit).unwrap() / length);
	};


}
