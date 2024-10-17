// [dependencies]
// primal = "0.3"

fn main() {
    let limit = 1000;
    let mut sum = 0;
    println!("count  prime      sum");
    for (n, p) in primal::Sieve::new(limit)
        .primes_from(2)
        .take_while(|x| *x < limit)
        .enumerate()
    {
        sum += p;
        if primal::is_prime(sum as u64) {
            println!("  {:>3}    {:>3}    {:>5}", n + 1, p, sum);
        }
    }
}
