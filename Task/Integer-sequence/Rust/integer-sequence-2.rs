extern crate num;

use num::bigint::BigUint;
use num::traits::{One,Zero};

fn main() {
    let mut i: BigUint = BigUint::one();
    loop {
        println!("{}", i);
        i = i + BigUint::one();
    }
}
