// [dependencies]
// primal = "0.3"

fn get_digits(mut n: usize) -> [usize; 10] {
    let mut digits = [0; 10];
    while n > 0 {
        digits[n % 10] += 1;
        n /= 10;
    }
    digits
}

fn ormiston_pairs() -> impl std::iter::Iterator<Item = (usize, usize)> {
    let mut digits = [0; 10];
    let mut prime = 0;
    let mut primes = primal::Primes::all();
    std::iter::from_fn(move || {
        for p in primes.by_ref() {
            let prime0 = prime;
            prime = p;
            let digits0 = digits;
            digits = get_digits(prime);
            if digits == digits0 {
                return Some((prime0, prime));
            }
        }
        None
    })
}

fn main() {
    let mut count = 0;
    let mut op = ormiston_pairs();
    println!("First 30 Ormiston pairs:");
    for (p1, p2) in op.by_ref() {
        count += 1;
        let c = if count % 3 == 0 { '\n' } else { ' ' };
        print!("({:5}, {:5}){}", p1, p2, c);
        if count == 30 {
            break;
        }
    }
    println!();
    let mut limit = 1000000;
    for (p1, _) in op.by_ref() {
        if p1 > limit {
            println!("Number of Ormiston pairs < {}: {}", limit, count);
            limit *= 10;
            if limit == 10000000000 {
                break;
            }
        }
        count += 1;
    }
}
