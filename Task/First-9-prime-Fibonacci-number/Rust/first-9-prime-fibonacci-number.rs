// [dependencies]
// rug = "1.15.0"
// primal = "0.3"

use rug::{Assign, Integer};

fn fibonacci() -> impl std::iter::Iterator<Item = Integer> {
    let mut f0 = Integer::from(0);
    let mut f1 = Integer::from(1);
    std::iter::from_fn(move || {
        let result = Integer::from(&f0);
        let f = Integer::from(&f0 + &f1);
        f0.assign(&f1);
        f1.assign(&f);
        Some(result)
    })
}

fn prime_fibonacci() -> impl std::iter::Iterator<Item = (usize, Integer)> {
    use rug::integer::IsPrime;
    let mut primes = primal::Primes::all().skip(2);
    let mut fib = fibonacci();
    let mut n = 0;
    std::iter::from_fn(move || loop {
        if n > 4 {
            let p = primes.next().unwrap();
            while p > n {
                fib.next();
                n += 1;
            }
        }
        n += 1;
        if let Some(f) = fib.next() {
            if f.is_probably_prime(30) != IsPrime::No {
                return Some((n - 1, f));
            }
        }
    })
}

fn to_string(num: &Integer) -> String {
    let str = num.to_string();
    let len = str.len();
    if len > 40 {
        let mut result = String::from(&str[..20]);
        result.push_str("...");
        result.push_str(&str[len - 20..]);
        result.push_str(" (");
        result.push_str(&len.to_string());
        result.push_str(" digits)");
        return result;
    }
    str
}

fn main() {
    use std::time::Instant;
    let now = Instant::now();
    for (i, (n, f)) in prime_fibonacci().take(26).enumerate() {
        println!("{}: F({}) = {}", i + 1, n, to_string(&f));
    }
    let time = now.elapsed();
    println!("elapsed time: {} milliseconds", time.as_millis());
}
