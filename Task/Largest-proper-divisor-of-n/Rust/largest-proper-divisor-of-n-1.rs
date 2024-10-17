fn largest_proper_divisor(n: i32) -> i32 {
    for i in 2..=(n as f64).sqrt() as i32 {
        if n % i == 0 {
            return n / i;
        }
    }
}

fn main() {
    println!("The largest proper divisors for numbers in the interval [1, 100] are:");
    print!(" 1  ");
    for n in 2..=100 {
        if n % 2 == 0 {
            print!("{:2}  ", n / 2);
        } else {
            print!("{:2}  ", largest_proper_divisor(n));
        }
        if n % 10 == 0 {
            println!();
        }
    }
}
