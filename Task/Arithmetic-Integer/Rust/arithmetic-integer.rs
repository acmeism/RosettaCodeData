use std::env;

fn main() {
    let args: Vec<_> = env::args().collect();
    let a = args[1].parse::<i32>().unwrap();
    let b = args[2].parse::<i32>().unwrap();

    println!("sum:              {}", a + b);
    println!("difference:       {}", a - b);
    println!("product:          {}", a * b);
    println!("integer quotient: {}", a / b); // truncates towards zero
    println!("remainder:        {}", a % b); // same sign as first operand
}
