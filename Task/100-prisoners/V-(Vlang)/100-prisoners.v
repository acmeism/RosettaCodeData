import rand
import rand.seed
// Uses 0-based numbering rather than 1-based numbering throughout.
fn do_trials(trials int, np int, strategy string) {
    mut pardoned := 0
    for _ in 0..trials {
        mut drawers := []int{len: 100, init: it}
        rand.shuffle<int>(mut drawers) or {panic('shuffle failed')}
        mut next_trial := false
        for p in 0..np {
            mut next_prisoner := false
            if strategy == "optimal" {
                mut prev := p
                for _ in 0..50 {
                    this := drawers[prev]
                    if this == p {
                        next_prisoner = true
                        break
                    }
                    prev = this
                }
            } else {
                // Assumes a prisoner remembers previous drawers (s)he opened
                // and chooses at random from the others.
                mut opened := [100]bool{}
                for _ in 0..50 {
                    mut n := 0
                    for {
                        n = rand.intn(100) or {0}
                        if !opened[n] {
                            opened[n] = true
                            break
                        }
                    }
                    if drawers[n] == p {
                        next_prisoner = true
                        break
                    }
                }
            }
            if !next_prisoner {
                next_trial = true
                break
            }
        }
        if !next_trial {
            pardoned++
        }
    }
    rf := f64(pardoned) / f64(trials) * 100
    println("  strategy = ${strategy:-7}  pardoned = ${pardoned:-6} relative frequency = ${rf:-5.2f}%\n")
}

fn main() {
    rand.seed(seed.time_seed_array(2))
    trials := 100000
    for np in [10, 100] {
        println("Results from $trials trials with $np prisoners:\n")
        for strategy in ["random", "optimal"] {
            do_trials(trials, np, strategy)
        }
    }
}
