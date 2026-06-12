use rand::seq::SliceRandom;
use rand::thread_rng;
use std::collections::HashSet;

const NUMBERS: [&str; 3] = ["ONE", "TWO", "THREE"];
const COLOURS: [&str; 3] = ["GREEN", "RED", "PURPLE"];
const SHADINGS: [&str; 3] = ["OPEN", "SOLID", "SRIPED"];
const SHAPES: [&str; 3] = ["DIAMOND", "OVAL", "SQUIGGLE"];

type Card = Vec<String>;

fn create_pack_of_cards() -> Vec<Card> {
    let mut pack = Vec::new();
    for number in NUMBERS.iter() {
        for colour in COLOURS.iter() {
            for shading in SHADINGS.iter() {
                for shape in SHAPES.iter() {
                    let card = vec![
                        number.to_string(),
                        colour.to_string(),
                        shading.to_string(),
                        shape.to_string(),
                    ];
                    pack.push(card);
                }
            }
        }
    }
    pack
}

fn all_same_or_all_different(triple: &[Card], index: usize) -> bool {
    let mut triple_set = HashSet::new();
    for card in triple {
        triple_set.insert(&card[index]);
    }
    triple_set.len() == 1 || triple_set.len() == 3
}

fn is_game_set(triple: &[Card]) -> bool {
    all_same_or_all_different(triple, 0)
        && all_same_or_all_different(triple, 1)
        && all_same_or_all_different(triple, 2)
        && all_same_or_all_different(triple, 3)
}

fn combinations<T: Clone>(list: &[T], choose: usize) -> Vec<Vec<T>> {
    let mut combinations = Vec::new();
    let mut combination: Vec<usize> = (0..choose).collect();

    while combination[choose - 1] < list.len() {
        let mut entry = Vec::new();
        for &value in &combination {
            entry.push(list[value].clone());
        }
        combinations.push(entry);

        let mut temp = choose - 1;
        while temp != 0 && combination[temp] == list.len() - choose + temp {
            temp -= 1;
        }
        combination[temp] += 1;
        for i in temp + 1..choose {
            combination[i] = combination[i - 1] + 1;
        }
    }
    combinations
}

fn main() {
    let mut rng = thread_rng();

    let mut pack = create_pack_of_cards();
    for &card_count in &[4, 8, 12] {
        pack.shuffle(&mut rng);
        let deal: Vec<Card> = pack.iter().take(card_count).cloned().collect();

        println!("Cards dealt: {}", card_count);
        for card in &deal {
            println!("[{} {} {} {}]", card[0], card[1], card[2], card[3]);
        }
        println!();

        println!("Sets found: ");
        for combination in combinations(&deal, 3) {
            if is_game_set(&combination) {
                for card in &combination {
                    print!("[{} {} {} {}] ", card[0], card[1], card[2], card[3]);
                }
                println!();
            }
        }
        println!("-------------------------\n");
    }
}
