import "std/random.zc"
import "locale.h"

let rng: Random;

fn shuffle(a: int*, len: usize) {
    for let i: usize = len - 1; i >= 1; --i {
        let j = rng.next_int_range(0, (int)i);
        if j != i {
            let t = a[i];
            a[i] = a[j];
            a[j] = t;
        }
    }
}

fn do_trials(trials: int, np: int, strategy: string) {
    let pardoned = 0;
    for t in 0..trials {
        let drawers: [int; 100];
        for i in 0..100 { drawers[i] = i; }
        shuffle((int*)drawers, 100);
        let next_trial = false;
        for p in 0..np {
            let next_prisoner = false;
            if strcmp(strategy, "optimal") == 0 {
                let prev = p;
                for d in 0..50 {
                    let curr = drawers[prev];
                    if curr == p {
                        next_prisoner = true;
                        break;
                    }
                    prev = curr;
                }
            } else {
                let opened: [bool; 100];
                for d in 0..50 {
                    let n: int;
                    loop {
                        n = rng.next_int_range(0, 99);
                        if !opened[n] {
                            opened[n] = true;
                            break;
                        }
                    }
                    if drawers[n] == p {
                        next_prisoner = true;
                        break;
                    }
                }
            }
            if !next_prisoner {
                next_trial = true;
                break;
            }
        }
        if !next_trial { pardoned++; }
    }
    let rf = (f64)pardoned / (f64)trials * 100.0;
    println "  strategy = {strategy:-7s}  pardoned = {pardoned:'6d}  relative frequency = {rf:5.2f}%\n";
}

fn main() {
    rng = Random::new();
    setlocale(LC_NUMERIC, "");
    let trials = 100_000;
    let nps = [10, 100];
    let strategies = ["random", "optimal"];
    for np in nps {
        println "Results from {trials:'d} trials with {np} prisoners:\n";
        for i in 0..strategies.len { do_trials(trials, np, strategies[i]); }
    }
}
