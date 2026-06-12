fn prime_sieve(limit: usize) -> Vec<bool> {
    let mut sieve = vec![true; limit];
    if limit > 0 {
        sieve[0] = false;
    }
    if limit > 1 {
        sieve[1] = false;
    }
    for i in (4..limit).step_by(2) {
        sieve[i] = false;
    }
    let mut p = 3;
    loop {
        let mut q = p * p;
        if q >= limit {
            break;
        }
        if sieve[p] {
            let inc = 2 * p;
            while q < limit {
                sieve[q] = false;
                q += inc;
            }
        }
        p += 2;
    }
    sieve
}

fn strange_unique_prime_triplets(limit: usize, verbose: bool) {
    if limit < 6 {
        return;
    }
    let mut primes = Vec::new();
    let sieve = prime_sieve(limit * 3);
    for p in (3..limit).step_by(2) {
        if sieve[p] {
            primes.push(p);
        }
    }
    if verbose {
        println!("Strange unique prime triplets < {}:", limit);
    }
    let mut count = 0;
    let n = primes.len();
    for i in 0..n - 2 {
        for j in i + 1..n - 1 {
            for k in j + 1..n {
                let sum = primes[i] + primes[j] + primes[k];
                if sieve[sum] {
                    count += 1;
                    if verbose {
                        println!(
                            "{:2} + {:2} + {:2} = {:2}",
                            primes[i], primes[j], primes[k], sum
                        );
                    }
                }
            }
        }
    }
    println!(
        "Count of strange unique prime triplets < {} is {}.",
        limit, count
    );
}

fn main() {
    strange_unique_prime_triplets(30, true);
    strange_unique_prime_triplets(1000, false);
}
