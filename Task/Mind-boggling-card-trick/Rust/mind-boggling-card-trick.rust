extern crate rand; // 0.5.5
use rand::Rng;
use std::iter::repeat;

#[derive(Debug, Eq, PartialEq, Clone)]
enum Colour {
    Black,
    Red,
}
use Colour::*;

fn main() {
    let mut rng = rand::thread_rng();

    //Create our deck.
    let mut deck: Vec<_> = repeat(Black).take(26)
        .chain(repeat(Red).take(26))
        .collect();

    rng.shuffle(&mut deck);

    let mut black_stack = vec![];
    let mut red_stack = vec![];
    let mut discarded = vec![];

    //Deal our cards.
    print!("Discarding:");
    while let (Some(card), Some(next)) = (deck.pop(), deck.pop()) {
        print!(" {}", if card == Black { "B" } else { "R" });
        match card {
            Red => red_stack.push(next),
            Black => black_stack.push(next),
        }
        discarded.push(card);
    }
    println!();

    // Choose how many to swap.
    let max = red_stack.len().min(black_stack.len());
    let num = rng.gen_range(1, max);
    println!("Exchanging {} cards", num);

    // Actually swap our cards.
    for _ in 0..num {
        let red = rng.choose_mut(&mut red_stack).unwrap();
        let black = rng.choose_mut(&mut black_stack).unwrap();
        std::mem::swap(red, black);
    }

    //Count how many are red and black.
    let num_black = black_stack.iter()
        .filter(|&c| c == &Black)
        .count();
    let num_red = red_stack.iter()
        .filter(|&c| c == &Red)
        .count();

    println!("Number of black cards in black stack: {}", num_black);
    println!("Number of red cards in red stack: {}", num_red);
}
