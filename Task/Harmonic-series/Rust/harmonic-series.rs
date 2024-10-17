use num::rational::Ratio;
use num::BigInt;
use std::num::NonZeroU64;

fn main() {
    for n in 1..=20 {
        // `harmonic_number` takes the type `NonZeroU64`,
        // which is just a normal u64 which is guaranteed to never be 0.
        // We convert n into this type with `n.try_into().unwrap()`,
        // where the unwrap is okay because n is never 0.
        println!(
            "Harmonic number {n} = {}",
            harmonic_number(n.try_into().unwrap())
        );
    }

    // The unwrap here is likewise okay because 100 is not 0.
    println!(
        "Harmonic number 100 = {}",
        harmonic_number(100.try_into().unwrap())
    );

    // In order to avoid recomputing all the terms in the sum for every harmonic number
    // we save the value of the harmonic series between loop iterations
    // and just add 1/iter to it.

    let mut target = 1;
    let mut iter = 1;
    let mut harmonic_number: Ratio<BigInt> = Ratio::from_integer(1.into());

    while target <= 10 {
        if harmonic_number > Ratio::from_integer(target.into()) {
            println!("Position of first term > {target} is {iter}");
            target += 1;
        }

        // Compute the next term in the harmonic series.
        iter += 1;
        harmonic_number += Ratio::from_integer(iter.into()).recip();
    }
}

fn harmonic_number(n: NonZeroU64) -> Ratio<BigInt> {
    // Convert each integer from 1 to n into an arbitrary precision rational number
    // and sum their reciprocals.
    (1..=n.get())
        .map(|i| Ratio::from_integer(i.into()).recip())
        .sum()
}
