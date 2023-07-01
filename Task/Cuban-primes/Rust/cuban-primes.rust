use std::time::Instant;
use separator::Separatable;

const NUMBER_OF_CUBAN_PRIMES: usize = 200;
const COLUMNS: usize = 10;
const LAST_CUBAN_PRIME: usize = 100_000;

fn main() {
    println!("Calculating the first {} cuban primes and the {}th cuban prime...", NUMBER_OF_CUBAN_PRIMES, LAST_CUBAN_PRIME);
    let start = Instant::now();

    let mut i: u64 = 0;
    let mut j: u64 = 1;
    let mut index: usize = 0;
    let mut cuban_primes = Vec::new();
    let mut cuban: u64 = 0;
    while index < 100_000 {
        cuban = {j += 1; j}.pow(3) - {i += 1; i}.pow(3);
        if primal::is_prime(cuban) {
            if index < NUMBER_OF_CUBAN_PRIMES {
                cuban_primes.push(cuban);
            }
            index += 1;
        }
    }

    let elapsed = start.elapsed();
    println!("THE {} FIRST CUBAN PRIMES:", NUMBER_OF_CUBAN_PRIMES);
    cuban_primes
        .chunks(COLUMNS)
        .map(|chunk| {
            chunk.iter()
                .map(|item| {
                    print!("{}\t", item)
                })
                .for_each(drop);
            println!("");
        })
        .for_each(drop);
    println!("The {}th cuban prime number is {}", LAST_CUBAN_PRIME, cuban.separated_string());
    println!("Elapsed time: {:?}", elapsed);
}
