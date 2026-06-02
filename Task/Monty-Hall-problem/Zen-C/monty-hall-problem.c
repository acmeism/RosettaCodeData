import "std/random.zc"
import "locale.h";

fn monty_hall(games: int) {
    let rng = Random::new();
    let switch_wins = 0;
    let stay_wins = 0;
    for _ in 1..=games {
        let doors: int[3] = [0, 0, 0];         // all zero (goats) by default
        doors[rng.next_int_range(0, 2)] = 1;   // put car in a random door
        let choice = rng.next_int_range(0, 2); // choose a door at random
        let shown = 0;
        do {
            shown = rng.next_int_range(0, 2);   // the shown door
        } while doors[shown] == 1 || shown == choice;
        stay_wins += doors[choice];
        switch_wins += doors[3 - choice - shown];
    }
    setlocale(LC_NUMERIC, "en_US.UTF-8");
    println "Simulating {games:'d} games:";
    println "Staying   wins {stay_wins:'d} times";
    println "Switching wins {switch_wins:'d} times";
}

fn main() {
    monty_hall(1_000_000);
}
