extern crate rand;
use rand::Rng;
use rand::seq::SliceRandom;

#[derive(Clone, Copy, PartialEq)]
enum Prize {Goat , Car}

const GAMES: usize = 3_000_000;
fn main() {
    let mut switch_wins = 0;
    let mut rng = rand::thread_rng();

    for _ in 0..GAMES {
        let mut doors = [Prize::Goat; 3];
        *doors.choose_mut(&mut rng).unwrap() = Prize::Car;

        // You only lose by switching if you pick the car the first time
        if doors.choose(&mut rng).unwrap() != &Prize::Car {
            switch_wins += 1;
        }
    }
    println!("I played the game {total} times and won {wins} times ({percent}%).",
             total   = GAMES,
             wins    = switch_wins,
             percent = switch_wins as f64 / GAMES as f64 * 100.0
    );
}
