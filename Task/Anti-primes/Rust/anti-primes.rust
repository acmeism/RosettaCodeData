fn count_divisors(n: u64) -> usize {
    if n < 2 {
        return 1;
    }
    2 + (2..=(n / 2)).filter(|i| n % i == 0).count()
}

fn main() {
    println!("The first 20 anti-primes are:");
    (1..)
        .scan(0, |max, n| {
            let d = count_divisors(n);
            Some(if d > *max {
                *max = d;
                Some(n)
            } else {
                None
            })
        })
        .flatten()
        .take(20)
        .for_each(|n| print!("{} ", n));
    println!();
}
