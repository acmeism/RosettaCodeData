#![feature(iterator_step_by)]

extern crate primal;

fn is_prime(n: u64) -> bool {
    if n == 2 || n == 3 || n == 5 || n == 7 || n == 11 || n == 13 { return true; }
    if n % 2 == 0 || n % 3 == 0 || n % 5 == 0 || n % 7 == 0 || n % 11 == 0 || n % 13 == 0 { return false; }
    let root = (n as f64).sqrt() as u64 + 1;
    (17..root).step_by(2).all(|i| n % i != 0)
}

fn is_emirp(n: u64) -> bool {
    let mut aux = n;
    let mut rev_prime = 0;
    while aux > 0 {
        rev_prime = rev_prime * 10 + aux  % 10;
        aux /= 10;
    }
    if n == rev_prime { return false; }
    is_prime(rev_prime)
}

fn calculate() -> (Vec<usize>, Vec<usize>, usize) {
    let mut count = 1;
    let mut vec1 = Vec::new();
    let mut vec2 = Vec::new();
    let mut emirp_10_000 = 0;

    for i in primal::Primes::all() {
        if is_emirp(i as u64) {
            if count < 21 { vec1.push(i) }
            if i > 7_700 && i < 8_000 { vec2.push(i) }
            if count == 10_000 {
                emirp_10_000 = i;
                break;
            }
            count += 1;
        }
    }

    (vec1, vec2, emirp_10_000)
}

fn main() {
    let (vec1, vec2, emirp_10_000) = calculate();

    println!("First 20 emirp-s : {:?}", vec1);
    println!("Emirps-s between 7700 and 8000 : {:?}", vec2);
    println!("10.000-th emirp : {}", emirp_10_000);
}
