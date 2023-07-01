use std::iter::{empty, once};
use std::time::Instant;

fn basic_sieve(limit: usize) -> Box<Iterator<Item = usize>> {
    if limit < 2 { return Box::new(empty()) }

    let mut is_prime = vec![true; limit+1];
    is_prime[0] = false;
    if limit >= 1 { is_prime[1] = false }
    let sqrtlmt = (limit as f64).sqrt() as usize + 1;

    for num in 2..sqrtlmt {
        if is_prime[num] {
            let mut multiple = num * num;
            while multiple <= limit {
                is_prime[multiple] = false;
                multiple += num;
            }
        }
    }

    Box::new(is_prime.into_iter().enumerate()
                .filter_map(|(p, is_prm)| if is_prm { Some(p) } else { None }))

}

fn main() {
    let n = 1000000;
    let vrslt = basic_sieve(100).collect::<Vec<_>>();
    println!("{:?}", vrslt);
    let strt = Instant::now();

    // do it 1000 times to get a reasonable execution time span...
    let rslt = (1..1000).map(|_| basic_sieve(n)).last().unwrap();

    let elpsd = strt.elapsed();

    let count = rslt.count();
    println!("{}", count);

    let secs = elpsd.as_secs();
    let millis = (elpsd.subsec_nanos() / 1000000) as u64;
    let dur = secs * 1000 + millis;
    println!("Culling composites took {} milliseconds.", dur);
}
