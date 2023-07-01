// [dependencies]
// primal = "0.3"

fn main() {
    use std::collections::HashMap;

    let mut primes = primal::Primes::all();
    let mut last_prime = primes.next().unwrap();
    let mut gap_starts = HashMap::new();

    let mut find_gap_start = move |gap: usize| -> usize {
        if let Some(start) = gap_starts.get(&gap) {
            return *start;
        }
        loop {
            let prev = last_prime;
            last_prime = primes.next().unwrap();
            let diff = last_prime - prev;
            if !gap_starts.contains_key(&diff) {
                gap_starts.insert(diff, prev);
            }
            if gap == diff {
                return prev;
            }
        }
    };

    let limit = 100000000000;

    let mut pm = 10;
    let mut gap1 = 2;
    loop {
        let start1 = find_gap_start(gap1);
        let gap2 = gap1 + 2;
        let start2 = find_gap_start(gap2);
        let diff = if start2 > start1 {
            start2 - start1
        } else {
            start1 - start2
        };
        if diff > pm {
            println!(
                "Earliest difference > {} between adjacent prime gap starting primes:\n\
                Gap {} starts at {}, gap {} starts at {}, difference is {}.\n",
                pm, gap1, start1, gap2, start2, diff
            );
            if pm == limit {
                break;
            }
            pm *= 10;
        } else {
            gap1 = gap2;
        }
    }
}
