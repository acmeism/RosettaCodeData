extern crate num_traits;
extern crate num;

use num::bigint::{BigInt, ToBigInt};
use num_traits::{Zero, One};
use std::collections::HashMap;

// Return a vector of all fibonacci results from fib(1) to fib(n)
fn fib(n: usize) -> Vec<BigInt> {
    let mut result = Vec::with_capacity(n);
    let mut a = BigInt::zero();
    let mut b = BigInt::one();

    result.push(b.clone());

    for i in 1..n {
        let t = b.clone();
        b = a+b;
        a = t;
        result.push(b.clone());
    }

    result
}

// Return the first digit of a `BigInt`
fn first_digit(x: &BigInt) -> u8 {
    let zero = BigInt::zero();
    assert!(x > &zero);

    let s = x.to_str_radix(10);

    // parse the first digit of the stringified integer
    *&s[..1].parse::<u8>().unwrap()
}

fn main() {
    const N: usize = 1000;
    let mut counter: HashMap<u8, u32> = HashMap::new();
    for x in fib(N) {
        let d = first_digit(&x);
        *counter.entry(d).or_insert(0) += 1;
    }

    println!("{:>13}    {:>10}", "real", "predicted");
    for y in 1..10 {
        println!("{}: {:10.3} v. {:10.3}", y, *counter.get(&y).unwrap_or(&0) as f32 / N as f32,
        (1.0 + 1.0 / (y as f32)).log10());
    }

}
