// [dependencies]
// primal = "0.3"
// num-format = "0.4"

use num_format::{Locale, ToFormattedString};

fn twin_prime_count_for_powers_of_ten(max_power: u32) {
    let mut count = 0;
    let mut previous = 0;
    let mut power = 1;
    let mut limit = 10;
    for prime in primal::Primes::all() {
        if prime > limit {
            println!(
                "Number of twin prime pairs less than {} is {}",
                limit.to_formatted_string(&Locale::en),
                count.to_formatted_string(&Locale::en)
            );
            limit *= 10;
            power += 1;
            if power > max_power {
                break;
            }
        }
        if previous > 0 && prime == previous + 2 {
            count += 1;
        }
        previous = prime;
    }
}

fn twin_prime_count(limit: usize) {
    let mut count = 0;
    let mut previous = 0;
    for prime in primal::Primes::all().take_while(|x| *x < limit) {
        if previous > 0 && prime == previous + 2 {
            count += 1;
        }
        previous = prime;
    }
    println!(
        "Number of twin prime pairs less than {} is {}",
        limit.to_formatted_string(&Locale::en),
        count.to_formatted_string(&Locale::en)
    );
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() > 1 {
        for i in 1..args.len() {
            if let Ok(limit) = args[i].parse::<usize>() {
                twin_prime_count(limit);
            } else {
                eprintln!("Cannot parse limit from string {}", args[i]);
            }
        }
    } else {
        twin_prime_count_for_powers_of_ten(10);
    }
}
