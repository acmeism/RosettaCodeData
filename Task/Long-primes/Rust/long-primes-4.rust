fn is_oddprime(n: u64) -> bool {
    let limit = (n as f64).sqrt().ceil() as u64;
    (3..=limit).step_by(2).all(|a| n % a > 0)
}

fn divisors(n: u64) -> Vec<u64> {
    let list1: Vec<u64> = (1..=(n as f64).sqrt().floor() as u64)
            .filter(|d| n % d == 0).collect();
    let list2: Vec<u64> = list1.iter().rev()
            .skip_while(|&d| d * d == n).map(|d| n / d).collect();
    [list1, list2].concat()
}

fn power_mod(base: u64, exp: u64, modulo: u64) -> u64 {
    fn iter(base: u64, modu: &u64, exp: u64, res: u64) -> u64 {
        if exp > 0 {
            let base1 = (base * base) % modu;
            let res1 = if exp & 1 > 0 {(base * res) % modu} else {res};
            iter(base1, modu, exp >> 1, res1)
        }
        else {res}
    }
    iter(base, &modulo, exp, 1)
}

// the smallest divisor d of p-1 such that 10^d = 1 (mod p)
// is the length of the period of the decimal expansion of 1/p
fn is_longprime(p: u64) -> bool {
    match divisors(p - 1).into_iter()
            .skip_while(|&d| power_mod(10, d, p) != 1)
            .next() {
                Some(d) => d + 1 == p,
                None => false
            }
}

fn long_primes() -> impl Iterator<Item = u64> {
     (7..).step_by(2).filter(|&p|is_oddprime(p))
            .filter(|&p| is_longprime(p))
}

fn main() {
    println!("long primes up to 500:");
    let list500: Vec<u64> = long_primes()
                .take_while(|&p| p <= 500)
                .collect();
    println!("{:?}\n", list500);

    let limits: Vec<u64> = (0..8).map(|n| 2u64.pow(n) * 500).collect();
    for limit in limits {
        let start = std::time::Instant::now();
        let count = long_primes().take_while(|&p| p <= limit).count();
        let duration = start.elapsed().as_millis();
        println!("there are {:4} long primes up to {:5} [time(ms) {:3}]",
            count, limit, duration);
    }
}
