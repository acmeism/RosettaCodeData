use rand::seq::SliceRandom;
use rand::thread_rng;

const SUITS: [&str; 4] = ["♣", "♦", "♥", "♠"];
const FACES: [&str; 13] = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"];

struct Card {
    display: String,
    rank: usize,
}

impl Card {
    fn new(index: usize) -> Self {
        let face = FACES[index % 13];
        let suit = SUITS[index / 13];
        Card {
            display: format!("{}{}", face, suit),
            rank: index % 13,
        }
    }
}

fn war() {
    // Create and shuffle deck
    let mut deck: Vec<usize> = (0..52).collect();
    deck.shuffle(&mut thread_rng());

    // Deal cards to players (reversing order to match Go implementation)
    let mut hand1: Vec<usize> = Vec::with_capacity(52);
    let mut hand2: Vec<usize> = Vec::with_capacity(52);

    for i in 0..26 {
        hand1.push(deck[2 * i]);
        hand2.push(deck[2 * i + 1]);
    }
    hand1.reverse();
    hand2.reverse();

    // Create cards lookup
    let cards: Vec<Card> = (0..52).map(Card::new).collect();

    while !hand1.is_empty() && !hand2.is_empty() {
        let card1 = hand1.remove(0);
        let card2 = hand2.remove(0);

        let mut played1 = vec![card1];
        let mut played2 = vec![card2];
        let mut num_played = 2;

        let mut current_card1 = card1;
        let mut current_card2 = card2;

        loop {
            print!("{}\t{}\t", cards[current_card1].display, cards[current_card2].display);

            if cards[current_card1].rank > cards[current_card2].rank {
                hand1.extend(played1);
                hand1.extend(played2);
                println!("Player 1 takes the {} cards. Now has {}.", num_played, hand1.len());
                break;
            } else if cards[current_card1].rank < cards[current_card2].rank {
                hand2.extend(played2);
                hand2.extend(played1);
                println!("Player 2 takes the {} cards. Now has {}.", num_played, hand2.len());
                break;
            } else {
                println!("War!");

                if hand1.len() < 2 {
                    println!("Player 1 has insufficient cards left.");
                    hand2.extend(played2);
                    hand2.extend(played1);
                    hand2.extend(hand1.drain(..));
                    break;
                }

                if hand2.len() < 2 {
                    println!("Player 2 has insufficient cards left.");
                    hand1.extend(played1);
                    hand1.extend(played2);
                    hand1.extend(hand2.drain(..));
                    break;
                }

                let fd_card1 = hand1.remove(0); // face down card
                current_card1 = hand1.remove(0); // face up card
                played1.push(fd_card1);
                played1.push(current_card1);

                let fd_card2 = hand2.remove(0); // face down card
                current_card2 = hand2.remove(0); // face up card
                played2.push(fd_card2);
                played2.push(current_card2);

                num_played += 4;
                println!("? \t? \tFace down cards.");
            }
        }
    }

    if hand1.len() == 52 {
        println!("Player 1 wins the game!");
    } else {
        println!("Player 2 wins the game!");
    }
}

fn main() {
    war();
}
