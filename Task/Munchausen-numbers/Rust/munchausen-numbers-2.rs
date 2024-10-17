use num_bigint::BigUint;
use num_traits::cast::ToPrimitive;
use rayon::prelude::*;

fn main() {
    // Helper function to compute the Munchausen sum
    fn munchausen_sum(num: &BigUint) -> BigUint {
        num.to_string()
            .chars()
            .map(|c| {
                let digit = c.to_digit(10).unwrap();
                if digit == 0 {
                    BigUint::from(0u32)
                } else {
                    BigUint::from(digit).pow(digit)
                }
            })
            .sum::<BigUint>()
    }

    // Loop through the desired range
    let start = BigUint::from(0u128);
    let end = BigUint::from(1_000_00u128);
    let solutions: Vec<BigUint> = (start.to_u128().unwrap()..end.to_u128().unwrap())
        .into_par_iter()
        .map(|n| BigUint::from(n))
        .filter(|num| munchausen_sum(num) == *num)
        .collect();

    for solution in &solutions {
        println!("Munchausen number found: {:?}", solution);
    }

    println!("Munchausen numbers below {:?}: {:?}", end, solutions);
}
