extern crate num_bigint; // 0.3.0
extern crate num_rational; // 0.3.0

use num_bigint::BigInt;
use num_rational::BigRational;


use std::ops::{Add, Mul};
use std::fmt;

fn main() {
    let hamburger = Currency::new(5.50);
    let milkshake = Currency::new(2.86);
    let pre_tax = hamburger * 4_000_000_000_000_000 + milkshake * 2;
    println!("Price before tax: {}", pre_tax);
    let tax = pre_tax.calculate_tax();
    println!("Tax: {}", tax);
    let post_tax = pre_tax + tax;
    println!("Price after tax: {}", post_tax);
}

#[derive(Debug)]
struct Currency {
    amount: BigRational,
}

impl Add for Currency {

    type Output = Self;

    fn add(self, other: Self) -> Self {
        Self {
            amount: self.amount + other.amount,
        }
    }
}

impl Mul<u64> for Currency {

    type Output = Self;

    fn mul(self, other: u64) -> Self {
        Self {
            amount: self.amount * BigInt::from(other),
        }
    }
}

impl fmt::Display for Currency {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let cents = (&self.amount * BigInt::from(100)).to_integer();
        write!(f, "${}.{:0>2}", &cents / 100, &cents % 100)
    }
}

impl Currency {

    fn new(num: f64) -> Self {
        Self {
            amount: BigRational::new(((num * 100.0).round() as i64).into(), 100.into())
        }
    }

    fn calculate_tax(&self) -> Self {
        let tax_val = BigRational::new(765.into(), 100.into());// 7,65 -> 0.0765 after the next line
        let amount = (&self.amount * tax_val).ceil() / BigInt::from(100);
        Self {
            amount
        }
    }
}
