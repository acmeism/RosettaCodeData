import "std/random.zc"
import "locale.h"

let rng: Random;

fn sleeping_beauty(reps: int) -> f64 {
    let wakings = 0;
    let heads = 0;
    for _ in 0..reps {
        let coin = rng.next_int_range(0, 1) // heads = 0, tails = 1 say
        wakings++;
        if coin == 0 {
            heads++;
        } else {
            wakings++;
        }
    }
    println "Wakings over {reps:'d} repetitions = {wakings:'d}";
    let pc = (f64)heads / (f64)wakings * 100.0;
    println "Percentage probability of heads on waking = {pc:g}%";
}

fn main() {
    setlocale(LC_NUMERIC, "");
    rng = Random::new();
    sleeping_beauty(1_000_000);
}
