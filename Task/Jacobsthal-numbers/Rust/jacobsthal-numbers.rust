// [dependencies]
// rug = "0.3"

use rug::integer::IsPrime;
use rug::Integer;

fn jacobsthal_numbers() -> impl std::iter::Iterator<Item = Integer> {
    (0..).map(|x| ((Integer::from(1) << x) - if x % 2 == 0 { 1 } else { -1 }) / 3)
}

fn jacobsthal_lucas_numbers() -> impl std::iter::Iterator<Item = Integer> {
    (0..).map(|x| (Integer::from(1) << x) + if x % 2 == 0 { 1 } else { -1 })
}

fn jacobsthal_oblong_numbers() -> impl std::iter::Iterator<Item = Integer> {
    let mut jn = jacobsthal_numbers();
    let mut n0 = jn.next().unwrap();
    std::iter::from_fn(move || {
        let n1 = jn.next().unwrap();
        let result = Integer::from(&n0 * &n1);
        n0 = n1;
        Some(result)
    })
}

fn jacobsthal_primes() -> impl std::iter::Iterator<Item = Integer> {
    jacobsthal_numbers().filter(|x| x.is_probably_prime(30) != IsPrime::No)
}

fn main() {
    println!("First 30 Jacobsthal Numbers:");
    for (i, n) in jacobsthal_numbers().take(30).enumerate() {
        print!("{:9}{}", n, if (i + 1) % 5 == 0 { "\n" } else { " " });
    }
    println!("\nFirst 30 Jacobsthal-Lucas Numbers:");
    for (i, n) in jacobsthal_lucas_numbers().take(30).enumerate() {
        print!("{:9}{}", n, if (i + 1) % 5 == 0 { "\n" } else { " " });
    }
    println!("\nFirst 20 Jacobsthal oblong Numbers:");
    for (i, n) in jacobsthal_oblong_numbers().take(20).enumerate() {
        print!("{:11}{}", n, if (i + 1) % 5 == 0 { "\n" } else { " " });
    }
    println!("\nFirst 20 Jacobsthal primes:");
    for n in jacobsthal_primes().take(20) {
        println!("{}", n);
    }
}
