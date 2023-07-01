// main.rs
// References:
// https://en.wikipedia.org/wiki/Full_reptend_prime
// https://en.wikipedia.org/wiki/Primitive_root_modulo_n#Finding_primitive_roots

mod bit_array;
mod prime_sieve;

use prime_sieve::PrimeSieve;

fn modpow(mut base: usize, mut exp: usize, n: usize) -> usize {
    if n == 1 {
        return 0;
    }
    let mut result = 1;
    base %= n;
    while exp > 0 {
        if (exp & 1) == 1 {
            result = (result * base) % n;
        }
        base = (base * base) % n;
        exp >>= 1;
    }
    result
}

fn is_long_prime(sieve: &PrimeSieve, prime: usize) -> bool {
    if !sieve.is_prime(prime) {
        return false;
    }
    if 10 % prime == 0 {
        return false;
    }
    let n = prime - 1;
    let mut m = n;
    let mut p = 2;
    while p * p <= n {
        if sieve.is_prime(p) && m % p == 0 {
            if modpow(10, n / p, prime) == 1 {
                return false;
            }
            while m % p == 0 {
                m /= p;
            }
        }
        p += 1;
    }
    if m == 1 {
        return true;
    }
    modpow(10, n / m, prime) != 1
}

fn long_primes(limit1: usize, limit2: usize) {
    let sieve = PrimeSieve::new(limit2);
    let mut count = 0;
    let mut limit = limit1;
    let mut prime = 3;
    while prime < limit2 {
        if is_long_prime(&sieve, prime) {
            if prime < limit1 {
                print!("{} ", prime);
            }
            if prime > limit {
                print!("\nNumber of long primes up to {}: {}", limit, count);
                limit *= 2;
            }
            count += 1;
        }
        prime += 2;
    }
    println!("\nNumber of long primes up to {}: {}", limit, count);
}

fn main() {
    long_primes(500, 8192000);
}
