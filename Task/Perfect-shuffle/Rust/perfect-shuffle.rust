extern crate itertools;

fn shuffle<T>(mut deck: Vec<T>) -> Vec<T> {
    let index = deck.len() / 2;
    let right_half = deck.split_off(index);
    itertools::interleave(deck, right_half).collect()
}

fn main() {
    for &size in &[8, 24, 52, 100, 1020, 1024, 10_000] {
        let original_deck: Vec<_> = (0..size).collect();
        let mut deck = original_deck.clone();
        let mut iterations = 0;
        loop {
            deck = shuffle(deck);
            iterations += 1;
            if deck == original_deck {
                break;
            }
        }
        println!("{: >5}: {: >4}", size, iterations);
    }
}
