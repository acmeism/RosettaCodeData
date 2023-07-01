use std::collections::HashMap;
use itertools::Itertools;

fn cubes(n: u64) -> Vec<u64> {
	let mut cube_vector = Vec::new();
	for i in 1..=n {
		cube_vector.push(i.pow(3));
	}
	cube_vector
}

fn main() {
	let c = cubes(1201);
	let it = c.iter().combinations(2);
	let mut m = HashMap::new();
	for x in it {
		let sum = x[0] + x[1];
		m.entry(sum).or_insert(Vec::new()).push(x)
	}
	
	let mut result = Vec::new();
	
	for (k,v) in m.iter() {
		if v.len() > 1 {
			result.push((k,v));
		}
	}
	
	result.sort();
	for f in result {
		println!("{:?}", f);
	}
}
