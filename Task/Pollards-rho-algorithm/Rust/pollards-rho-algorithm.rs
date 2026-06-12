use num_integer::gcd;
use rand::Rng;

fn pollards_rho(number: i128) -> i128 {
	if number & 1 == 0 {
        return 2;
    }
	let bit_length = number.ilog2() as u32;
    let mut x = rand::thread_rng().gen_range(0..2_i64.pow(bit_length)) as i128;
	let constant = rand::thread_rng().gen_range(0..2_i64.pow(bit_length)) as i128;
	let mut y = x;
	let mut divisor = 1;
	while divisor == 1 {
        x = ( x * x + constant ) % number;
	    y = ( y * y + constant ) % number;
	    y = ( y * y + constant ) % number;
	    divisor = gcd(x - y, number);
    }
	return divisor;
}

fn main() {
    let tests = [ 4294967213, 9759463979, 34225158206557151, 13 ];
    for test in tests {
	    let divisor_one = pollards_rho(test);
        let divisor_two = test / divisor_one;
        println!("{} = {} * {}", test, divisor_one, divisor_two);
    }
}
