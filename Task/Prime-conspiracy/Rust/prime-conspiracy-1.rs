// main.rs
mod bit_array;
mod prime_sieve;

use prime_sieve::PrimeSieve;

// See https://en.wikipedia.org/wiki/Prime_number_theorem#Approximations_for_the_nth_prime_number
fn upper_bound_for_nth_prime(n: usize) -> usize {
    let x = n as f64;
    (x * (x.ln() + x.ln().ln())) as usize
}

fn compute_transitions(limit: usize) {
    use std::collections::BTreeMap;
    let mut transitions = BTreeMap::new();
    let mut prev = 2;
    let mut count = 0;
    let sieve = PrimeSieve::new(upper_bound_for_nth_prime(limit));
    let mut n = 3;
    while count < limit {
        if sieve.is_prime(n) {
            count += 1;
            let digit = n % 10;
            let key = (prev, digit);
            if let Some(v) = transitions.get_mut(&key) {
                *v += 1;
            } else {
                transitions.insert(key, 1);
            }
            prev = digit;
        }
        n += 2;
    }
    println!("First {} prime numbers:", limit);
    for ((from, to), c) in &transitions {
        let freq = 100.0 * (*c as f32) / (limit as f32);
        println!(
            "{} -> {}: count = {:7}, frequency = {:.2} %",
            from, to, c, freq
        );
    }
}

fn main() {
    compute_transitions(1000000);
    println!();
    compute_transitions(100000000);
}
