use rand::prelude::*;
use std::collections::VecDeque;

struct Riffle;

impl Riffle {
    fn shuffle(&self, v: &mut VecDeque<i32>, tm: i32) {
        let mut tmp = VecDeque::new();
        self.copy_to(v, &mut tmp);

        for _ in 0..tm {
            let mut rng = rand::thread_rng();
            let lhand_size = rng.gen_range(0..(tmp.len() / 3)) + (tmp.len() >> 1);
            let mut lhand = VecDeque::with_capacity(lhand_size);
            let mut rhand = VecDeque::with_capacity(tmp.len() - lhand_size);

            // Split into left and right hands
            for i in 0..tmp.len() {
                if i < lhand_size {
                    if let Some(val) = tmp.get(i) {
                        lhand.push_back(*val);
                    }
                } else {
                    if let Some(val) = tmp.get(i) {
                        rhand.push_back(*val);
                    }
                }
            }
            tmp.clear();

            // Interleave cards from both hands
            while !lhand.is_empty() && !rhand.is_empty() {
                let fl = rng.gen_range(0..10) < 5;
                let mut len = if fl {
                    if lhand.len() > 3 {
                        rng.gen_range(1..=3)
                    } else {
                        rng.gen_range(1..=lhand.len())
                    }
                } else {
                    if rhand.len() > 3 {
                        rng.gen_range(1..=3)
                    } else {
                        rng.gen_range(1..=rhand.len())
                    }
                };

                while len > 0 && !lhand.is_empty() && !rhand.is_empty() {
                    if fl {
                        if let Some(val) = lhand.pop_front() {
                            tmp.push_front(val);
                        }
                    } else {
                        if let Some(val) = rhand.pop_front() {
                            tmp.push_front(val);
                        }
                    }
                    len -= 1;
                }
            }

            // Handle remaining cards
            while let Some(val) = rhand.pop_front() {
                tmp.push_front(val);
            }

            while let Some(val) = lhand.pop_front() {
                tmp.push_front(val);
            }
        }

        self.copy_to(&mut tmp, v);
    }

    fn copy_to(&self, a: &mut VecDeque<i32>, b: &mut VecDeque<i32>) {
        for &x in a.iter() {
            b.push_back(x);
        }
        a.clear();
    }
}

struct Overhand;

impl Overhand {
    fn shuffle(&self, v: &mut VecDeque<i32>, tm: i32) {
        let mut tmp = VecDeque::new();

        for _ in 0..tm {
            while !v.is_empty() {
                let mut rng = rand::thread_rng();
                let len = rng.gen_range(1..=v.len());
                let top = rng.gen_range(0..10) < 5;

                for _ in 0..len {
                    if v.is_empty() { break; }

                    if let Some(val) = v.pop_front() {
                        if top {
                            tmp.push_back(val);
                        } else {
                            tmp.push_front(val);
                        }
                    }
                }
            }

            // Move all cards back to v
            while let Some(val) = tmp.pop_front() {
                v.push_back(val);
            }
        }
    }
}

fn fill() -> VecDeque<i32> {
    let mut cards = VecDeque::new();
    for x in 1..=20 {
        cards.push_back(x);
    }
    cards
}

fn display(title: &str, cards: &VecDeque<i32>) {
    println!("{}", title);
    for &card in cards.iter() {
        print!("{} ", card);
    }
    println!("\n");
}

fn main() {
    let riffle = Riffle;
    let overhand = Overhand;

    // Riffle shuffle
    let mut cards = fill();
    riffle.shuffle(&mut cards, 10);
    display("RIFFLE", &cards);

    // Overhand shuffle
    let mut cards = fill();
    overhand.shuffle(&mut cards, 10);
    display("OVERHAND", &cards);

    // Standard shuffle
    let mut cards = fill();
    let mut cards_vec: Vec<i32> = cards.into_iter().collect();
    cards_vec.shuffle(&mut rand::thread_rng());
    let cards: VecDeque<i32> = cards_vec.into_iter().collect();
    display("STD SHUFFLE", &cards);
}
