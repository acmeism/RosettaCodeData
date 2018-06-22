extern crate num;
use num::bigint::BigUint;
use num::FromPrimitive;
use num::pow::pow;

fn main() {
    let big = BigUint::from_u8(5).unwrap();
    let answer_as_string = format!("{}", pow(big,pow(4,pow(3,2))));

      // The rest is output formatting.
    let first_twenty: String = answer_as_string.chars().take(20).collect();
    let last_twenty_reversed: Vec<char> = answer_as_string.chars().rev().take(20).collect();
    let last_twenty: String = last_twenty_reversed.into_iter().rev().collect();
    println!("Number of digits: {}", answer_as_string.len());
    println!("First and last digits: {:?}..{:?}", first_twenty, last_twenty);
}
