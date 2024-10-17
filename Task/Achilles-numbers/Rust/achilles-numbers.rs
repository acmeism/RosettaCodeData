fn perfect_powers(n: u128) -> Vec<u128> {
    let mut powers = Vec::<u128>::new();
    let sqrt = (n as f64).sqrt() as u128;
    for i in 2..=sqrt {
        let mut p = i * i;
        while p < n {
            powers.push(p);
            p *= i;
        }
    }
    powers.sort();
    powers.dedup();
    powers
}

fn bsearch<T: Ord>(vector: &Vec<T>, value: &T) -> bool {
    match vector.binary_search(value) {
        Ok(_) => true,
        _ => false,
    }
}

fn achilles(from: u128, to: u128, pps: &Vec<u128>) -> Vec<u128> {
    let mut result = Vec::<u128>::new();
    let cbrt = ((to / 4) as f64).cbrt() as u128;
    let sqrt = ((to / 8) as f64).sqrt() as u128;
    for b in 2..=cbrt {
        let b3 = b * b * b;
        for a in 2..=sqrt {
            let p = b3 * a * a;
            if p >= to {
                break;
            }
            if p >= from && !bsearch(&pps, &p) {
                result.push(p);
            }
        }
    }
    result.sort();
    result.dedup();
    result
}

fn totient(mut n: u128) -> u128 {
    let mut tot = n;
    if (n & 1) == 0 {
        while (n & 1) == 0 {
            n >>= 1;
        }
        tot -= tot >> 1;
    }
    let mut p = 3;
    while p * p <= n {
        if n % p == 0 {
            while n % p == 0 {
                n /= p;
            }
            tot -= tot / p;
        }
        p += 2;
    }
    if n > 1 {
        tot -= tot / n;
    }
    tot
}

fn main() {
    use std::time::Instant;
    let t0 = Instant::now();
    let limit = 1000000000000000u128;

    let pps = perfect_powers(limit);
    let ach = achilles(1, 1000000, &pps);

    println!("First 50 Achilles numbers:");
    for i in 0..50 {
        print!("{:4}{}", ach[i], if (i + 1) % 10 == 0 { "\n" } else { " " });
    }

    println!("\nFirst 50 strong Achilles numbers:");
    for (i, n) in ach
        .iter()
        .filter(|&x| bsearch(&ach, &totient(*x)))
        .take(50)
        .enumerate()
    {
        print!("{:6}{}", n, if (i + 1) % 10 == 0 { "\n" } else { " " });
    }
    println!();

    let mut from = 1u128;
    let mut to = 100u128;
    let mut digits = 2;
    while to <= limit {
        let count = achilles(from, to, &pps).len();
        println!("{:2} digits: {}", digits, count);
        from = to;
        to *= 10;
        digits += 1;
    }

    let duration = t0.elapsed();
    println!("\nElapsed time: {} milliseconds", duration.as_millis());
}
