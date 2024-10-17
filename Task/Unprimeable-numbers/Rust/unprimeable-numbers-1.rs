// main.rs
mod bit_array;
mod prime_sieve;

use prime_sieve::PrimeSieve;

// return number of decimal digits
fn count_digits(mut n: u32) -> u32 {
    let mut digits = 0;
    while n > 0 {
        n /= 10;
        digits += 1;
    }
    digits
}

// return the number with one digit replaced
fn change_digit(mut n: u32, mut index: u32, new_digit: u32) -> u32 {
    let mut p = 1;
    let mut changed = 0;
    while index > 0 {
        changed += p * (n % 10);
        p *= 10;
        n /= 10;
        index -= 1;
    }
    changed += (10 * (n / 10) + new_digit) * p;
    changed
}

fn unprimeable(sieve: &PrimeSieve, n: u32) -> bool {
    if sieve.is_prime(n as usize) {
        return false;
    }
    let d = count_digits(n);
    for i in 0..d {
        for j in 0..10 {
            let m = change_digit(n, i, j);
            if m != n && sieve.is_prime(m as usize) {
                return false;
            }
        }
    }
    true
}

fn main() {
    let mut count = 0;
    let mut n = 100;
    let mut lowest = vec![0; 10];
    let mut found = 0;
    let sieve = PrimeSieve::new(10000000);
    println!("First 35 unprimeable numbers:");
    while count < 600 || found < 10 {
        if unprimeable(&sieve, n) {
            if count < 35 {
                if count > 0 {
                    print!(", ");
                }
                print!("{}", n);
            }
            count += 1;
            if count == 600 {
                println!("\n600th unprimeable number: {}", n);
            }
            let last_digit = n as usize % 10;
            if lowest[last_digit] == 0 {
                lowest[last_digit] = n;
                found += 1;
            }
        }
        n += 1;
    }
    for i in 0..10 {
        println!("Least unprimeable number ending in {}: {}", i, lowest[i]);
    }
}
