// [dependencies]
// primal = "0.3"
// radix_fmt = "1.0"

fn reverse(base: u64, mut n: u64) -> u64 {
    let mut rev = 0;
    while n > 0 {
        rev = rev * base + n % base;
        n /= base;
    }
    rev
}

fn palindromes(base: u64) -> impl std::iter::Iterator<Item = u64> {
    let mut lower = 1;
    let mut upper = base;
    let mut next = 0;
    let mut even = false;
    std::iter::from_fn(move || {
        next += 1;
        if next == upper {
            if even {
                lower = upper;
                upper *= base;
            }
            next = lower;
            even = !even;
        }
        Some(match even {
            true => next * upper + reverse(base, next),
            _ => next * lower + reverse(base, next / base),
        })
    })
}

fn print_palindromic_primes(base: u64, limit: u64) {
    let width = (limit as f64).log(base as f64).ceil() as usize;
    let mut count = 0;
    let columns = 80 / (width + 1);
    println!("Base {} palindromic primes less than {}:", base, limit);
    for p in palindromes(base)
        .take_while(|x| *x < limit)
        .filter(|x| primal::is_prime(*x))
    {
        count += 1;
        print!(
            "{:>w$}",
            radix_fmt::radix(p, base as u8).to_string(),
            w = width
        );
        if count % columns == 0 {
            println!();
        } else {
            print!(" ");
        }
    }
    if count % columns != 0 {
        println!();
    }
    println!("Count: {}", count);
}

fn count_palindromic_primes(base: u64, limit: u64) {
    let c = palindromes(base)
        .take_while(|x| *x < limit)
        .filter(|x| primal::is_prime(*x))
        .count();
    println!(
        "Number of base {} palindromic primes less than {}: {}",
        base, limit, c
    );
}

fn main() {
    print_palindromic_primes(10, 1000);
    println!();
    print_palindromic_primes(10, 100000);
    println!();
    count_palindromic_primes(10, 1000000000);
    println!();
    print_palindromic_primes(16, 500);
}
