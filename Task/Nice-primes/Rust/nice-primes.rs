// [dependencies]
// primal = "0.3"

fn digital_root(n: u64) -> u64 {
    if n == 0 {
        0
    } else {
        1 + (n - 1) % 9
    }
}

fn nice_primes(from: usize, to: usize) {
    primal::Sieve::new(to)
        .primes_from(from)
        .take_while(|x| *x < to)
        .filter(|x| primal::is_prime(digital_root(*x as u64)))
        .for_each(|x| println!("{}", x));
}

fn main() {
    nice_primes(500, 1000);
}
