use primes::{is_prime,factors_uniq};

/// True if non-prime n's factors, all > 9, are all substrings of its representation in base 10
fn contains_its_prime_factors_all_over_7(n: u64) -> bool {
    if n < 10 || is_prime(n) {
        return false;
    }
    let strn = &n.to_string();
    let pfacs = factors_uniq(n);
    return pfacs.iter().all(|f| f > &9 && strn.contains(&f.to_string()));
}

fn main() {
    let mut found = 0;
    // 20 of these < 30 million
    for n in 0..30_000_000 {
        if contains_its_prime_factors_all_over_7(n) {
            found += 1;
            print!("{:12}{}", n, {if found % 10 == 0 {"\n"} else {""}});
            if found == 20 {
                break;
            }
        }
    }
}
