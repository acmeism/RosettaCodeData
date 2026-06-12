// Importing the Itertools crate to use the `permutations` and `unique` methods.
use itertools::Itertools;

// Importing Instant from std::time to measure the execution time of the function.
use std::time::Instant;

// Define constants
const MAX_DIGITS: usize = 9; // We only consider digits 1 through 9 for pandigital numbers
const MAX_LIMIT: usize = 987_654_321; // We will not consider numbers above this limit

// Checks whether a given number is prime.
// A prime number is greater than 1 and divisible only by 1 and itself.
fn is_prime(n: usize) -> bool {
    // Reject numbers less than 2 and even numbers greater than 2
    if n < 2 || (n % 2 == 0 && n != 2) {
        return false;
    }

    // Check for divisibility from 3 to the square root of n, skipping even numbers
    let sqrt_n = (n as f64).sqrt() as usize;
    (3..=sqrt_n).step_by(2).all(|i| n % i != 0)
}

// Generates a vector of characters representing digits from 1 to n.
// Example: digit_chars(3) returns vec!['1', '2', '3']
fn digit_chars(n: usize) -> Vec<char> {
    (1..=n).map(|d| (b'0' + d as u8) as char).collect()
}

// Checks if the sum of the digits is divisible by 3.
// If so, every permutation will also be divisible by 3, meaning they're not prime.
fn divisible_by_3(digits: &[char]) -> bool {
    let sum: usize = digits
        .iter()
        .map(|c| c.to_digit(10).unwrap() as usize) // Convert each char to digit
        .sum();
    sum % 3 == 0
}

// Finds all prime pandigital numbers less than the given limit.
// A pandigital number uses all digits from 1 to n exactly once (e.g., 123, 3214, etc.)
fn find_pandigital_primes(limit: usize) {
    let start_time = Instant::now(); // Start measuring execution time

    let mut total = 0; // Counts total valid pandigital numbers
    let mut prime_count = 0; // Counts how many are prime
    let mut max_prime = 0; // Stores the largest pandigital prime found

    // Try generating pandigital numbers with 1 to MAX_DIGITS digits
    for n in 1..=MAX_DIGITS {
        let digits = digit_chars(n); // Generate digit list ['1', '2', ..., 'n']

        // If the sum of the digits is divisible by 3, all permutations are divisible by 3
        if divisible_by_3(&digits) {
            continue; // Skip this n
        }

        // Generate all unique permutations of the digit list
        for perm in digits.iter().permutations(n).unique() {
            // Skip if the first digit is '0' (leading zeros are not allowed)
            if perm[0] == &'0' {
                continue;
            }

            // Convert the permutation (Vec<&char>) into a String and then to a number
            let num: usize = perm.iter().copied().collect::<String>().parse().unwrap();

            // Skip if the number exceeds the limit
            if num >= limit {
                continue;
            }

            total += 1; // Count as a valid pandigital number

            // Check if the number is prime
            if is_prime(num) {
                prime_count += 1; // Count as a prime
                if num > max_prime {
                    max_prime = num; // Update maximum prime if this one is larger
                }
            }
        }
    }

    let duration = start_time.elapsed(); // Stop timing

    // Print results
    println!("Largest prime pandigital number: {}", max_prime);
    println!("Execution time: {:?}", duration);
}

// Entry point of the program
fn main() {
    find_pandigital_primes(MAX_LIMIT);
}

