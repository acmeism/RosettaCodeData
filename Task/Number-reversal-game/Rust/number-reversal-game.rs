use rand::prelude::*;
use std::io::stdin;

fn is_sorted(seq: &[impl PartialOrd]) -> bool {
    if seq.len() < 2 {
        return true;
    }
    // Look for any instance where the previous number is larger than the following
    !seq.iter()
        .zip(seq[1..].iter())
        .any(|(prev, foll)| prev > foll)
}

fn main() {
    println!(
        "Number reversal game:
    Given a jumbled list of the numbers 1 to 9, put the numbers in order.
    Each attempt you can reverse up to n digits starting from the left.
    The score is the count of the reversals needed to attain the ascending order."
    );
    let mut rng = thread_rng();

    let mut sequence: Vec<u8> = (1..10).collect();
    while is_sorted(&sequence) {
        sequence.shuffle(&mut rng);
    }

    let mut attempt = 1;
    while !is_sorted(&sequence) {
        println!(
            "Attempt {}: {:?} - How many numbers do you want to flip?",
            attempt, sequence
        );
        let flip = {
            let mut input = String::new();
            stdin().read_line(&mut input).unwrap();
            input.trim().parse().unwrap()
        };
        sequence[..flip].reverse();
        attempt += 1;
    }
    println!(
        "Congrats! It took you {} attempts to sort the sequence.",
        attempt - 1 // Remove additionally counted attempt
    );
}
