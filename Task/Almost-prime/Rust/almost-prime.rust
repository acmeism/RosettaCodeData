fn is_kprime(n: u32, k: u32) -> bool {
    let mut primes = 0;
    let mut f = 2;
    let mut rem = n;
    while primes < k && rem > 1{
        while (rem % f) == 0 && rem > 1{
            rem /= f;
            primes += 1;
        }
        f += 1;
    }
    rem == 1 && primes == k
}

struct KPrimeGen {
    k: u32,
    n: u32,
}

impl Iterator for KPrimeGen {
    type Item = u32;
    fn next(&mut self) -> Option<u32> {
        self.n += 1;
        while !is_kprime(self.n, self.k) {
            self.n += 1;
        }
        Some(self.n)
    }
}

fn kprime_generator(k: u32) -> KPrimeGen {
    KPrimeGen {k: k, n: 1}
}

fn main() {
    for k in 1..6 {
        println!("{}: {:?}", k, kprime_generator(k).take(10).collect::<Vec<_>>());
    }
}
