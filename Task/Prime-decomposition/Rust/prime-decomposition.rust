use num_bigint::BigUint;
use num_traits::{One, Zero};
use std::fmt::{Display, Formatter};

#[derive(Clone, Debug)]
pub struct Factors {
    pub number: BigUint,
    pub result: Vec<BigUint>,
}

impl Factors {
    pub fn of(number: BigUint) -> Factors {
        let mut factors = Self {
            number: number.clone(),
            result: Vec::new(),
        };

        let big_2 = BigUint::from(2u8);
        let big_4 = BigUint::from(4u8);

        factors.check(&big_2);
        factors.check(&BigUint::from(3u8));

        let mut divisor = BigUint::from(5u8);
        while &divisor * &divisor <= factors.number {
            factors.check(&divisor);
            divisor += &big_2;
            factors.check(&divisor);
            divisor += &big_4;
        }

        if factors.number > BigUint::one() {
            factors.result.push(factors.number);
        }

        factors.number = number; // Restore the number
        factors
    }

    pub fn is_prime(&self) -> bool {
        self.result.len() == 1
    }

    fn check(&mut self, divisor: &BigUint) {
        while (&self.number % divisor).is_zero() {
            self.result.push(divisor.clone());
            self.number /= divisor;
        }
    }
}

impl Display for Factors {
    fn fmt(&self, f: &mut Formatter) -> std::fmt::Result {
        let mut iter = self.result.iter();

        match iter.next() {
            None => write!(f, "[]"),

            Some(first) => {
                write!(f, "[{}", first)?;
                for next in iter {
                    write!(f, ", {}", next)?;
                }

                write!(f, "]")
            }
        }
    }
}

fn print_factors(number: BigUint) {
    let factors = Factors::of(number);

    if factors.is_prime() {
        println!("{} -> {} (prime)", factors.number, factors);
    } else {
        println!("{} -> {}", factors.number, factors);
    }
}

fn main() {
    print_factors(24u32.into());
    print_factors(32u32.into());
    print_factors(37u32.into());

    // Find Mersenne primes

    for n in 2..70 {
        print!("2**{} - 1: ", n);
        print_factors((BigUint::from(2u8) << n) - BigUint::one());
    }
}
