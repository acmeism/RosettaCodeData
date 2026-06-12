use std::collections::HashMap;

type DigitSet = [u32; 10];

fn get_digits(mut n: u64) -> DigitSet {
    let mut result = [0; 10];
    while n > 0 {
        result[(n % 10) as usize] += 1;
        n /= 10;
    }
    result
}

fn is_prime(n: u64) -> bool {
    if n < 2 {
        return false;
    }
    if n == 2 {
        return true;
    }
    if n % 2 == 0 {
        return false;
    }

    let sqrt_n = (n as f64).sqrt() as u64;
    for i in (3..=sqrt_n).step_by(2) {
        if n % i == 0 {
            return false;
        }
    }
    true
}

fn next_prime(start: u64) -> u64 {
    let mut candidate = if start < 2 { 2 } else { start };
    if candidate % 2 == 0 && candidate > 2 {
        candidate += 1;
    }

    while !is_prime(candidate) {
        candidate += if candidate == 2 { 1 } else { 2 };
    }
    candidate
}

fn main() {
    let mut current_prime = 2u64;
    let mut limit = 1000u64;

    while limit <= 100_000_00 {
        let mut anaprimes: HashMap<DigitSet, Vec<u64>> = HashMap::new();

        // Collect primes up to the current limit
        while current_prime <= limit {
            let digits = get_digits(current_prime);
            anaprimes.entry(digits).or_insert_with(Vec::new).push(current_prime);
            current_prime = next_prime(current_prime + 1);
        }

        // Find the largest group(s)
        let max_length = anaprimes.values().map(|v| v.len()).max().unwrap_or(0);

        let mut groups: Vec<&Vec<u64>> = anaprimes
            .values()
            .filter(|v| v.len() == max_length)
            .collect();

        // Sort groups by first element for consistent output
        groups.sort_by_key(|v| v.first().unwrap_or(&0));

        println!("Largest group(s) of anaprimes before {}: {} members:",
                 limit, max_length);

        for group in groups {
            println!("  First: {}  Last: {}",
                     group.first().unwrap(),
                     group.last().unwrap());
        }
        println!();

        limit *= 10;
    }
}
