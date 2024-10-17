extern crate aks_test_for_primes;

use std::iter::Filter;
use std::ops::RangeFrom;

use aks_test_for_primes::is_prime;

fn main() {
    for i in pernicious().take(25) {
        print!("{} ", i);
    }
    println!();
    for i in (888_888_877u64..888_888_888).filter(is_pernicious) {
        print!("{} ", i);
    }
}

fn pernicious() -> Filter<RangeFrom<u64>, fn(&u64) -> bool> {
    (0u64..).filter(is_pernicious as fn(&u64) -> bool)
}

fn is_pernicious(n: &u64) -> bool {
    is_prime(n.count_ones())
}
