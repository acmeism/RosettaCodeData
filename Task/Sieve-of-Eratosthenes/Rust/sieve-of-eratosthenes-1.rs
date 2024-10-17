fn primes(n: usize) -> impl Iterator<Item = usize> {
    const START: usize = 2;
    if n < START {
        Vec::new()
    } else {
        let mut is_prime = vec![true; n + 1 - START];
        let limit = (n as f64).sqrt() as usize;
        for i in START..limit + 1 {
            let mut it = is_prime[i - START..].iter_mut().step_by(i);
            if let Some(true) = it.next() {
                it.for_each(|x| *x = false);
            }
        }
        is_prime
    }
    .into_iter()
    .enumerate()
    .filter_map(|(e, b)| if b { Some(e + START) } else { None })
}
