use nums::{MillerRabin, PrimalityTest};
use num_bigint::BigUint;

fn largest_left_truncatable_prime(base: u128) -> u128 {
    let mut radix = 0_u32;
    let mut candidates = vec![0_u128];
    loop {
        let mut new_candidates: Vec<u128> = vec![];
        let multiplier = base.pow(radix);
        for i in 1..base {
            new_candidates.append(
                &mut candidates
                    .clone()
                    .into_iter()
                    .filter_map(|x| {
                        let y = x + i * multiplier;
                        if (MillerRabin{error_bits: 30}).is_prime(&BigUint::from(y)) {
                            Some(y)
                        } else {
                            None
                        }
                    })
                    .collect(),

            );
        }
        if new_candidates.len() == 0 {
            break;
        }
        candidates = new_candidates;
        radix += 1;
    }
    return candidates.into_iter().max().unwrap_or(0);
}

fn main() {
    for b in 3..18 {
        println!("{} : {}", b, largest_left_truncatable_prime(b));
    }
}
