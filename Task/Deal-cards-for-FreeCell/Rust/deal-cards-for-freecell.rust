// Code available at https://rosettacode.org/wiki/Linear_congruential_generator#Rust
extern crate linear_congruential_generator;

use linear_congruential_generator::{MsLcg, Rng, SeedableRng};

// We can't use `rand::Rng::shuffle` because it uses the more uniform `rand::Rng::gen_range`
// (`% range` is subject to modulo bias).  If an exact match of the old dealer is not needed,
// `rand::Rng::shuffle` should be used.
fn shuffle<T>(rng: &mut MsLcg, deck: &mut [T]) {
    let len = deck.len() as u32;
    for i in (1..len).rev() {
        let j = rng.next_u32() % (i + 1);
        deck.swap(i as usize, j as usize);
    }
}

fn gen_deck() -> Vec<String> {
    const RANKS: [char; 13] = ['A','2','3','4','5','6','7','8','9','T','J','Q','K'];
    const SUITS: [char; 4] = ['C', 'D', 'H', 'S'];

    let render_card = |card: usize| {
        let (suit, rank) = (card % 4, card / 4);
        format!("{}{}", RANKS[rank], SUITS[suit])
    };

    (0..52).map(render_card).collect()
}

fn deal_ms_fc_board(seed: u32) -> Vec<String> {
    let mut rng = MsLcg::from_seed(seed);
    let mut deck = gen_deck();

    shuffle(&mut rng, &mut deck);
    deck.reverse();

    deck.chunks(8).map(|row| row.join(" ")).collect::<Vec<_>>()
}

fn main() {
    let seed = std::env::args()
        .nth(1)
        .and_then(|n| n.parse().ok())
        .expect("A 32-bit seed is required");

    for row in deal_ms_fc_board(seed) {
        println!(": {}", row);
    }
}
