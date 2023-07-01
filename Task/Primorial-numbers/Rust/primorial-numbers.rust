extern crate primal;
extern crate rayon;
extern crate rug;

use rayon::prelude::*;
use rug::Integer;

fn partial(p1 : usize, p2 : usize) -> String {
    let mut aux = Integer::from(1);
    let (_, hi) = primal::estimate_nth_prime(p2 as u64);
    let sieve = primal::Sieve::new(hi as usize);
    let prime1 = sieve.nth_prime(p1);
    let prime2 = sieve.nth_prime(p2);

    for i in sieve.primes_from(prime1).take_while(|i| *i <= prime2) {
        aux = Integer::from(aux * i as u32);
    }
    aux.to_string_radix(10)
}

fn main() {
    let mut j1 = Integer::new();
    for k in [2,3,5,7,11,13,17,19,23,29].iter() {
        j1.assign_primorial(*k);
        println!("Primorial : {}", j1);
    }
    println!("Digits of primorial 10 : {}", partial(1, 10).chars().fold(0, |n, _| n + 1));
    println!("Digits of primorial 100 : {}", partial(1, 100).chars().fold(0, |n, _| n + 1));
    println!("Digits of primorial 1_000 : {}", partial(1, 1_000).chars().fold(0, |n, _| n + 1));
    println!("Digits of primorial 10_000 : {}", partial(1, 10_000).chars().fold(0, |n, _| n + 1));
    println!("Digits of primorial 100_000 : {}", partial(1, 100_000).chars().fold(0, |n, _| n + 1));

    let mut auxi = Integer::from(1);
    let ranges = vec![[1, 300_000], [300_001, 550_000], [550_001, 800_000], [800_001, 1_000_000]];
    let v = ranges.par_iter().map(|value| partial(value[0], value[1])).collect::<Vec<_>>();
    for i in v.iter() {
        auxi =Integer::from(&auxi * i.parse::<Integer>().unwrap());
    }
    let result = auxi.to_string_radix(10).chars().fold(0, |n, _| n+1);
    println!("Digits of primorial 1_000_000 : {}",result);
}
