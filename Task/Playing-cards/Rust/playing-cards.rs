extern crate rand;

use std::fmt;
use rand::Rng;
use Pip::*;
use Suit::*;

#[derive(Copy, Clone, Debug)]
enum Pip { Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King }

#[derive(Copy, Clone, Debug)]
enum Suit { Spades, Hearts, Diamonds, Clubs }

struct Card {
	pip: Pip,
	suit: Suit
}

impl fmt::Display for Card {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{:?} of {:?}", self.pip, self.suit)
    }
}

struct Deck(Vec<Card>);

impl Deck {
    fn new() -> Deck {
        let mut cards:Vec<Card> = Vec::with_capacity(52);
        for &suit in &[Spades, Hearts, Diamonds, Clubs] {
            for &pip in &[Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King] {
                cards.push( Card{pip: pip, suit: suit} );
            }
        }
        Deck(cards)
    }

    fn deal(&mut self) -> Option<Card> {
        self.0.pop()
    }

    fn shuffle(&mut self) {
        rand::thread_rng().shuffle(&mut self.0)
    }
}

impl fmt::Display for Deck {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        for card in self.0.iter() {
            writeln!(f, "{}", card);
        }
        write!(f, "")
    }
}

fn main() {
    let mut deck = Deck::new();
    deck.shuffle();
    //println!("{}", deck);
    for _ in 0..5 {
        println!("{}", deck.deal().unwrap());
    }
}
