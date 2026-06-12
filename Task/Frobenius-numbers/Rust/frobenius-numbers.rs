// [dependencies]
// primal = "0.3"

fn frobenius_numbers() -> impl std::iter::Iterator<Item = (usize, bool)> {
    let mut primes = primal::Primes::all();
    let mut prime = primes.next().unwrap();
    std::iter::from_fn(move || {
        if let Some(p) = primes.by_ref().next() {
            let fnum = prime * p - prime - p;
            prime = p;
            return Some((fnum, primal::is_prime(fnum as u64)));
        }
        None
    })
}

fn main() {
    let limit = 1000000;
    let mut count = 0;
    println!(
        "Frobenius numbers less than {} (asterisk marks primes):",
        limit
    );
    for (fnum, is_prime) in frobenius_numbers().take_while(|(x, _)| *x < limit) {
        count += 1;
        let c = if is_prime { '*' } else { ' ' };
        let s = if count % 10 == 0 { '\n' } else { ' ' };
        print!("{:6}{}{}", fnum, c, s);
    }
    println!();
}
