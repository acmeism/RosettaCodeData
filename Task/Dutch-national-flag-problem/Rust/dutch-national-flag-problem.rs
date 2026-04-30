extern crate rand; // 0.10.0 used

use rand::prelude::*;

// Color enums will be sorted by their top-to-bottom declaration order
#[derive(Eq,Ord,PartialOrd,PartialEq,Debug)]
enum Color {
    Red,
    White,
    Blue
}

fn is_sorted(list: &Vec<Color>) -> bool {
    let mut state = &Color::Red;
    for current in list.iter() {
        if current < state { return false; }
        if current > state { state = current; }
    }
    true
}

fn main() {
    let mut rng = rand::rng();
    let mut colors: Vec<Color> = Vec::new();

    for _ in 1..10 {
        let r = rng.random_range(0..3);
        if      r == 0 { colors.push(Color::Red); }
        else if r == 1 { colors.push(Color::White); }
        else if r == 2 { colors.push(Color::Blue); }
    }

    while is_sorted(&colors) {
        colors.shuffle(&mut rng);
    }

    println!("Before: {:?}", colors);
    colors.sort();
    println!("After:  {:?}", colors);
    if !is_sorted(&colors) {
        println!("Oops, did not sort colors correctly!");
    }
}
