use astro_float::{BigFloat, Consts, RoundingMode};
use num_bigint::BigInt;
use std::ops::{Div, Mul};
use std::str::FromStr;

const PR: usize = 228;
const RM: RoundingMode = RoundingMode::None;

fn factorial(n: u32) -> BigInt {
    let mut p = BigInt::from(1);
    for i in 2..=n {
        p *= i;
    }
    p
}

fn exponent_term(n: u32) -> u32 {
    6 * n + 3
}

fn integer_term(n: u32) -> BigInt {
    let p = 532 * n * n + 126 * n + 9;
    (p * BigInt::from(2).pow(5).mul(factorial(6 * n))).div(BigInt::from(3).mul(factorial(n).pow(6)))
}

fn nth_term(n: u32) -> BigFloat {
    let divisor = BigInt::from(10).pow(exponent_term(n));
    return BigFloat::from_str(&integer_term(n).to_string())
        .unwrap()
        .div(
            &BigFloat::from_str(&divisor.to_string()).unwrap(),
            PR,
            RoundingMode::Up,
        );
}

fn almkvist_guillera(float_precision: &BigFloat) -> BigFloat {
    let mut c = Consts::new().unwrap();
    let mut summed = nth_term(0);
    let mut next_sum = summed.clone();
    for n in 1..10000 {
        next_sum = summed.add(&nth_term(n), PR, RM);
        if (next_sum.sub(&summed, PR, RM)).abs()
            < BigFloat::from(10.0).pow(&(-float_precision), PR, RM, &mut c)
        {
            break;
        }
        summed = next_sum.clone();
    }
    next_sum
}

fn main() {
    let mut c = Consts::new().unwrap();
    println!(
        " N {:>21} {:>28} {:>20}\n{}\n",
        "NUMERATOR",
        "-EXP",
        "TERM (rounded)",
        "_".repeat(80)
    );
    for n in 0..10 {
        let mut t = nth_term(n);
        t.try_set_precision(64, RM, 64);
        println!(
            "{:>2}  {:<44}  {:>2}  {}",
            n,
            integer_term(n),
            exponent_term(n),
            t
        );
    }
    let pi_string = BigFloat::from(1.0)
        .div(
            &almkvist_guillera(&BigFloat::from(320)).sqrt(PR, RM),
            PR,
            RM,
        )
        .to_string();
    println!(
        "\nAlmkvist-Guillera π to 75 digits is {}\n",
        pi_string[..pi_string.len() - 6].to_string()
    );
    let library_pi_string = Consts::pi(&mut c, PR, RM).to_string();
    println!(
        "BigFloat (astro_float) library π is {}",
        library_pi_string[..library_pi_string.len() - 5].to_string()
    );
}
