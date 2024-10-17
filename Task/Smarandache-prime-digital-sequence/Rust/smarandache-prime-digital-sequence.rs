fn is_prime(n: u32) -> bool {
    if n < 2 {
        return false;
    }
    if n % 2 == 0 {
        return n == 2;
    }
    if n % 3 == 0 {
        return n == 3;
    }
    if n % 5 == 0 {
        return n == 5;
    }
    let mut p = 7;
    const WHEEL: [u32; 8] = [4, 2, 4, 2, 4, 6, 2, 6];
    loop {
        for w in &WHEEL {
            if p * p > n {
                return true;
            }
            if n % p == 0 {
                return false;
            }
            p += w;
        }
    }
}

fn next_prime_digit_number(n: u32) -> u32 {
    if n == 0 {
        return 2;
    }
    match n % 10 {
        2 => n + 1,
        3 | 5 => n + 2,
        _ => 2 + next_prime_digit_number(n / 10) * 10,
    }
}

fn smarandache_prime_digital_sequence() -> impl std::iter::Iterator<Item = u32> {
    let mut n = 0;
    std::iter::from_fn(move || {
        loop {
            n = next_prime_digit_number(n);
            if is_prime(n) {
                break;
            }
        }
        Some(n)
    })
}

fn main() {
    let limit = 1000000000;
    let mut seq = smarandache_prime_digital_sequence().take_while(|x| *x < limit);
    println!("First 25 SPDS primes:");
    for i in seq.by_ref().take(25) {
        print!("{} ", i);
    }
    println!();
    if let Some(p) = seq.by_ref().nth(99 - 25) {
        println!("100th SPDS prime: {}", p);
    }
    if let Some(p) = seq.by_ref().nth(999 - 100) {
        println!("1000th SPDS prime: {}", p);
    }
    if let Some(p) = seq.by_ref().nth(9999 - 1000) {
        println!("10,000th SPDS prime: {}", p);
    }
    if let Some(p) = seq.last() {
        println!("Largest SPDS prime less than {}: {}", limit, p);
    }
}
