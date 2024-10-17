extern crate rand;

use rand::prelude::*;

// Do a full run of checking boxes in a random order for a single prisoner
fn check_random_boxes(prisoner: u8, boxes: &[u8]) -> bool {
    let checks = {
        let mut b: Vec<u8> = (1u8..=100u8).collect();
        b.shuffle(&mut rand::thread_rng());
        b
    };
    checks.into_iter().take(50).any(|check| boxes[check as usize - 1] == prisoner)
}

// Do a full run of checking boxes in the optimized order for a single prisoner
fn check_ordered_boxes(prisoner: u8, boxes: &[u8]) -> bool {
    let mut next_check = prisoner;
    (0..50).any(|_| {
        next_check = boxes[next_check as usize - 1];
        next_check == prisoner
    })
}

fn main() {
    let mut boxes: Vec<u8> = (1u8..=100u8).collect();

    let trials = 100000;

    let ordered_successes = (0..trials).filter(|_| {
        boxes.shuffle(&mut rand::thread_rng());
        (1u8..=100u8).all(|prisoner| check_ordered_boxes(prisoner, &boxes))
    }).count();

    let random_successes = (0..trials).filter(|_| {
        boxes.shuffle(&mut rand::thread_rng());
        (1u8..=100u8).all(|prisoner| check_random_boxes(prisoner, &boxes))
    }).count();

    println!("{} / {} ({:.02}%) successes in ordered", ordered_successes, trials, ordered_successes as f64 * 100.0 / trials as f64);
    println!("{} / {} ({:.02}%) successes in random", random_successes, trials, random_successes as f64 * 100.0 / trials as f64);

}
