use itertools::Itertools;

// Sieve to precompute a boolean mask for primes up to 1000 for efficiency.
const PRIMES_MASK_LIMIT: usize = 1000;
lazy_static::lazy_static! {
    static ref PRIMES_MASK: Vec<bool> = {
        let mut primes = vec![true; PRIMES_MASK_LIMIT + 1];
        primes[0] = false;
        primes[1] = false;
        for p in 2..=PRIMES_MASK_LIMIT {
            if primes[p] {
                for multiple in (p * p..=PRIMES_MASK_LIMIT).step_by(p) {
                    primes[multiple] = false;
                }
            }
        }
        primes
    };
}

/// Returns true if the vector `v` (of i32) is a prime grouping, else false.
fn is_prime_group<T: Into<i32> + Copy>(v: &[T]) -> bool {
    for i in 0..v.len() {
        for j in (i + 1)..v.len() {
            let diff = (Into::<i32>::into(v[i]) - Into::<i32>::into(v[j])).abs() as usize;
            if diff >= PRIMES_MASK.len() || !PRIMES_MASK[diff] {
                return false;
            }
        }
    }
    true
}

/// Get all prime groupings of a slice of integers.
fn prime_groupings<T: Into<i32> + Copy + Ord>(a: &[T]) -> Vec<Vec<T>> {
    let mut result = Vec::new();
    for n in 2..=4.min(a.len()) {
        for c in a.iter().combinations(n) {
            let combination: Vec<T> = c.into_iter().copied().collect();
            if is_prime_group(&combination) {
                result.push(combination);
            }
        }
    }
    result
}

/// Count the number of prime groupings in a string of characters.
/// The string is first converted to a vector of integers, where each
/// character is represented by its ordinal value.
fn count_prime_groupings(s: &str) -> usize {
    let mut chars_as_ints: Vec<i32> = s.chars().map(|c| c as i32).collect();
    chars_as_ints.sort_unstable();
    prime_groupings(&chars_as_ints).len()
}

fn main() {
    loop {
        println!("Enter a string of characters (blank to exit): ");
        let mut input = String::new();
        std::io::stdin()
            .read_line(&mut input)
            .expect("Failed to read line");
        let trimmed = input.trim();
        if !trimmed.is_empty() {
            println!("{}", count_prime_groupings(trimmed));
        } else {
            println!("Exiting...");
            break;
        }
    }
}
