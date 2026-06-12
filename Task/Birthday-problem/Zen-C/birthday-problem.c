import "std/random.zc"

fn equal_birthdays(n_sharers: int, group_size: int, n_reps: int) -> f64 {
   let rng = Random::from_seed(1);
   let eq = 0;
   for i in 0..n_reps {
        let group: [int; 365];
        for j in 0..group_size {
            group[rng.next_int_range(0, 364)]++;
        }
        let t = false;
        for e in group {
            if e >= n_sharers {
                t = true;
                break;
            }
        }
        eq += t ? 1 : 0;
    }
    return (f64)eq * 100.0 / (f64)n_reps;
}

fn main() {
    let group_est = 2;
    for sharers in 2..6 {
        // Coarse.
        let group_size = group_est + 1;
        while equal_birthdays(sharers, group_size, 100) < 50.0 { group_size++; }

        // Finer.
        let inf = (int)(group_size - (group_size - group_est) / 4.0);
        for gs in inf..(group_size + 999) {
            let eq = equal_birthdays(sharers, group_size, 250);
            if eq > 50.0 {
                group_size = gs;
                break;
            }
        }

        // Finest.
        for gs in (group_size - 1)..(group_size + 999) {
            let eq = equal_birthdays(sharers, gs, 50_000);
            if eq > 50.0 {
                group_est = gs;
                print "{sharers} independent people in a group of {gs:3d} ";
                println "share a common birthday ({eq:2.1f}%)";
                break;
            }
        }
    }
}
