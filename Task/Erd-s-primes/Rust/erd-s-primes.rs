// [dependencies]
// primal = "0.3"

use std::collections::HashSet;

fn erdos_primes() -> impl std::iter::Iterator<Item = usize> {
    let mut primes = HashSet::new();
    let mut all_primes = primal::Primes::all();
    std::iter::from_fn(move || {
        'all_primes: for p in all_primes.by_ref() {
            primes.insert(p);
            let mut k = 1;
            let mut f = 1;
            while f < p {
                if primes.contains(&(p - f)) {
                    continue 'all_primes;
                }
                k += 1;
                f *= k;
            }
            return Some(p);
        }
        None
    })
}

fn main() {
    let mut count = 0;
    println!("Erd\u{151}s primes less than 2500:");
    for p in erdos_primes().take_while(|x| *x < 2500) {
        count += 1;
        if count % 10 == 0 {
            println!("{:4}", p);
        } else {
            print!("{:4} ", p);
        }
    }
    println!();
    if let Some(p) = erdos_primes().nth(7874) {
        println!("\nThe 7875th Erd\u{151}s prime is {}.", p);
    }
}
