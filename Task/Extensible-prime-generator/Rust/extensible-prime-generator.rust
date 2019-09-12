mod pagesieve;

use pagesieve::{count_primes_paged, primes_paged};

fn main() {
    println!("First 20 primes:\n {:?}",
             primes_paged().take(20).collect::<Vec<_>>());
    println!("Primes between 100 and 150:\n {:?}",
             primes_paged().skip_while(|&x| x < 100)
                           .take_while(|&x| x < 150)
                           .collect::<Vec<_>>());
    let diff = count_primes_paged(8000) - count_primes_paged(7700);
    println!("There are {} primes between 7,700 and 8,000", diff);
    // rust enumerations are zero base, so need to subtract 1!!!
    println!("The 10,000th prime is {}", primes_paged().nth(10_000 - 1).unwrap());
}
