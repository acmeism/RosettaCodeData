// [dependencies]
// rug = "1.13.0"

use rug::Integer;

fn generate_primes(limit: usize) -> Vec<usize> {
    let mut sieve = vec![true; limit >> 1];
    let mut p = 3;
    let mut sq = p * p;
    while sq < limit {
        if sieve[p >> 1] {
            let mut q = sq;
            while q < limit {
                sieve[q >> 1] = false;
                q += p << 1;
            }
        }
        sq += (p + 1) << 2;
        p += 2;
    }
    let mut primes = Vec::new();
    if limit > 2 {
        primes.push(2);
    }
    for i in 1..sieve.len() {
        if sieve[i] {
            primes.push((i << 1) + 1);
        }
    }
    primes
}

fn factorials(limit: usize) -> Vec<Integer> {
    let mut f = vec![Integer::from(1)];
    let mut factorial = Integer::from(1);
    f.reserve(limit);
    for i in 1..limit {
        factorial *= i as u64;
        f.push(factorial.clone());
    }
    f
}

fn main() {
    let limit = 11000;
    let f = factorials(limit);
    let primes = generate_primes(limit);
    println!(" n | Wilson primes\n--------------------");
    let mut s = -1;
    for n in 1..=11 {
        print!("{:2} |", n);
        for p in &primes {
            if *p >= n {
                let mut num = Integer::from(&f[n - 1] * &f[*p - n]);
                num -= s;
                if num % ((p * p) as u64) == 0 {
                    print!(" {}", p);
                }
            }
        }
        println!();
        s = -s;
    }
}
