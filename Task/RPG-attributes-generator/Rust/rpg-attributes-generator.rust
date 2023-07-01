use rand::distributions::Uniform;
use rand::prelude::{thread_rng, ThreadRng};
use rand::Rng;

fn main() {
    for _ in 0..=10 {
        attributes_engine();
    }
}

#[derive(Copy, Clone, Debug)]
pub struct Dice {
    amount: i32,
    range: Uniform<i32>,
    rng: ThreadRng,
}

impl Dice {
    //  Modeled after d20 polyhederal dice use and notation.
    //  roll_pool() - returns Vec<i32> with length of vector determined by dice amount.
    //  attribute_out() - returns i32, by sorting a dice pool of 4d6, dropping the lowest integer, and summing all elements.
    pub fn new(amount: i32, size: i32) -> Self {
        Self {
            amount,
            range: Uniform::new(1, size + 1),
            rng: thread_rng(),
        }
    }

    fn roll_pool(mut self) -> Vec<i32> {
        (0..self.amount)
            .map(|_| self.rng.sample(self.range))
            .collect()
    }

    fn attribute_out(&self) -> i32 {
        // Sort dice pool lowest to high and drain all results to exclude the lowest before summing.
        let mut attribute_array: Vec<i32> = self.roll_pool();
        attribute_array.sort();
        attribute_array.drain(1..=3).sum()
    }
}

fn attributes_finalizer() -> (Vec<i32>, i32, bool) {
    let die: Dice = Dice::new(4, 6);
    let mut attributes: Vec<i32> = Vec::new();

    for _ in 0..6 {
        attributes.push(die.attribute_out())
    }

    let attributes_total: i32 = attributes.iter().sum();

    let numerical_condition: bool = attributes
        .iter()
        .filter(|attribute| **attribute >= 15)
        .count()
        >= 2;

    (attributes, attributes_total, numerical_condition)
}

fn attributes_engine() {
    loop {
        let (attributes, attributes_total, numerical_condition) = attributes_finalizer();
        if (attributes_total >= 75) && (numerical_condition) {
            println!(
                "{:?} | sum: {:?}",
                attributes, attributes_total
            );
            break;
        } else {
            continue;
        }
    }
}
