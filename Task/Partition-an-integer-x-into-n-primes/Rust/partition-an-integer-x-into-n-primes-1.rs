// main.rs
mod bit_array;
mod prime_sieve;

use prime_sieve::PrimeSieve;

fn find_prime_partition(
    sieve: &PrimeSieve,
    number: usize,
    count: usize,
    min_prime: usize,
    primes: &mut Vec<usize>,
    index: usize,
) -> bool {
    if count == 1 {
        if number >= min_prime && sieve.is_prime(number) {
            primes[index] = number;
            return true;
        }
        return false;
    }
    for p in min_prime..number {
        if sieve.is_prime(p)
            && find_prime_partition(sieve, number - p, count - 1, p + 1, primes, index + 1)
        {
            primes[index] = p;
            return true;
        }
    }
    false
}

fn print_prime_partition(sieve: &PrimeSieve, number: usize, count: usize) {
    let mut primes = vec![0; count];
    if !find_prime_partition(sieve, number, count, 2, &mut primes, 0) {
        println!("{} cannot be partitioned into {} primes.", number, count);
    } else {
        print!("{} = {}", number, primes[0]);
        for i in 1..count {
            print!(" + {}", primes[i]);
        }
        println!();
    }
}

fn main() {
    let s = PrimeSieve::new(100000);
    print_prime_partition(&s, 99809, 1);
    print_prime_partition(&s, 18, 2);
    print_prime_partition(&s, 19, 3);
    print_prime_partition(&s, 20, 4);
    print_prime_partition(&s, 2017, 24);
    print_prime_partition(&s, 22699, 1);
    print_prime_partition(&s, 22699, 2);
    print_prime_partition(&s, 22699, 3);
    print_prime_partition(&s, 22699, 4);
    print_prime_partition(&s, 40355, 3);
}
