// [dependencies]
// primal = "0.3"
// indexing = "0.4.1"

fn get_primes_by_digits(limit: usize) -> Vec<Vec<usize>> {
    let mut primes_by_digits = Vec::new();
    let mut power = 10;
    let mut primes = Vec::new();
    for prime in primal::Primes::all().take_while(|p| *p < limit) {
        if prime > power {
            primes_by_digits.push(primes);
            primes = Vec::new();
            power *= 10;
        }
        primes.push(prime);
    }
    primes_by_digits.push(primes);
    primes_by_digits
}

fn main() {
    use indexing::algorithms::lower_bound;
    use std::time::Instant;

    let start = Instant::now();

    let primes_by_digits = get_primes_by_digits(1000000000);

    println!("First 100 brilliant numbers:");
    let mut brilliant_numbers = Vec::new();
    for primes in &primes_by_digits {
        for i in 0..primes.len() {
            let p1 = primes[i];
            for j in i..primes.len() {
                let p2 = primes[j];
                brilliant_numbers.push(p1 * p2);
            }
        }
        if brilliant_numbers.len() >= 100 {
            break;
        }
    }
    brilliant_numbers.sort();
    for i in 0..100 {
        let n = brilliant_numbers[i];
        print!("{:4}{}", n, if (i + 1) % 10 == 0 { '\n' } else { ' ' });
    }

    println!();
    let mut power = 10;
    let mut count = 0;
    for p in 1..2 * primes_by_digits.len() {
        let primes = &primes_by_digits[p / 2];
        let mut position = count + 1;
        let mut min_product = 0;
        for i in 0..primes.len() {
            let p1 = primes[i];
            let n = (power + p1 - 1) / p1;
            let j = lower_bound(&primes[i..], &n);
            let p2 = primes[i + j];
            let product = p1 * p2;
            if min_product == 0 || product < min_product {
                min_product = product;
            }
            position += j;
            if p1 >= p2 {
                break;
            }
        }
        println!("First brilliant number >= 10^{p} is {min_product} at position {position}");
        power *= 10;
        if p % 2 == 1 {
            let size = primes.len();
            count += size * (size + 1) / 2;
        }
    }

    let time = start.elapsed();
    println!("\nElapsed time: {} milliseconds", time.as_millis());
}
