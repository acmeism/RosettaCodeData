// [dependencies]
// rug = "1.15.0"

use rug::integer::IsPrime;
use rug::Integer;

fn cullen_number(n: u32) -> Integer {
    let num = Integer::from(n);
    (num << n) + 1
}

fn woodall_number(n: u32) -> Integer {
    let num = Integer::from(n);
    (num << n) - 1
}

fn main() {
    println!("First 20 Cullen numbers:");
    let cullen: Vec<String> = (1..21).map(|x| cullen_number(x).to_string()).collect();
    println!("{}", cullen.join(" "));

    println!("\nFirst 20 Woodall numbers:");
    let woodall: Vec<String> = (1..21).map(|x| woodall_number(x).to_string()).collect();
    println!("{}", woodall.join(" "));

    println!("\nFirst 5 Cullen primes in terms of n:");
    let cullen_primes: Vec<String> = (1..)
        .filter_map(|x| match cullen_number(x).is_probably_prime(25) {
            IsPrime::No => None,
            _ => Some(x.to_string()),
        })
        .take(5)
        .collect();
    println!("{}", cullen_primes.join(" "));

    println!("\nFirst 12 Woodall primes in terms of n:");
    let woodall_primes: Vec<String> = (1..)
        .filter_map(|x| match woodall_number(x).is_probably_prime(25) {
            IsPrime::No => None,
            _ => Some(x.to_string()),
        })
        .take(12)
        .collect();
    println!("{}", woodall_primes.join(" "));
}
