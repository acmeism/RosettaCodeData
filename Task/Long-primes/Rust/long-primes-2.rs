// prime_sieve.rs
use crate::bit_array;

pub struct PrimeSieve {
    composite: bit_array::BitArray,
}

impl PrimeSieve {
    pub fn new(limit: usize) -> PrimeSieve {
        let mut sieve = PrimeSieve {
            composite: bit_array::BitArray::new(limit / 2),
        };
        let mut p = 3;
        while p * p <= limit {
            if !sieve.composite.get(p / 2 - 1) {
                let inc = p * 2;
                let mut q = p * p;
                while q <= limit {
                    sieve.composite.set(q / 2 - 1, true);
                    q += inc;
                }
            }
            p += 2;
        }
        sieve
    }
    pub fn is_prime(&self, n: usize) -> bool {
        if n < 2 {
            return false;
        }
        if n % 2 == 0 {
            return n == 2;
        }
        !self.composite.get(n / 2 - 1)
    }
}
