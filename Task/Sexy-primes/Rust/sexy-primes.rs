// [dependencies]
// primal = "0.2"
// circular-queue = "0.2.5"

use circular_queue::CircularQueue;

fn main() {
    let max = 1000035;
    let max_group_size = 5;
    let diff = 6;
    let max_groups = 5;
    let max_unsexy = 10;

    let sieve = primal::Sieve::new(max + diff);
    let mut group_count = vec![0; max_group_size];
    let mut unsexy_count = 0;
    let mut groups = Vec::new();
    let mut unsexy_primes = CircularQueue::with_capacity(max_unsexy);

    for _ in 0..max_group_size {
        groups.push(CircularQueue::with_capacity(max_groups));
    }

    for p in sieve.primes_from(2).take_while(|x| *x < max) {
        if !sieve.is_prime(p + diff) && (p < diff + 2 || !sieve.is_prime(p - diff)) {
            unsexy_count += 1;
            unsexy_primes.push(p);
        } else {
            let mut group = Vec::new();
            group.push(p);
            for group_size in 1..max_group_size {
                let next = p + group_size * diff;
                if next >= max || !sieve.is_prime(next) {
                    break;
                }
                group.push(next);
                group_count[group_size] += 1;
                groups[group_size].push(group.clone());
            }
        }
    }

    for size in 1..max_group_size {
        println!(
            "Number of groups of size {} is {}",
            size + 1,
            group_count[size]
        );
        println!("Last {} groups of size {}:", groups[size].len(), size + 1);
        println!(
            "{}\n",
            groups[size]
                .asc_iter()
                .map(|g| format!("({})", to_string(&mut g.iter())))
                .collect::<Vec<String>>()
                .join(", ")
        );
    }
    println!("Number of unsexy primes is {}", unsexy_count);
    println!("Last {} unsexy primes:", unsexy_primes.len());
    println!("{}", to_string(&mut unsexy_primes.asc_iter()));
}

fn to_string<T: ToString>(iter: &mut dyn std::iter::Iterator<Item = T>) -> String {
    iter.map(|n| n.to_string())
        .collect::<Vec<String>>()
        .join(", ")
}
