// [dependencies]
// rug = "1.8"

fn is_prime(n: u32) -> bool {
    if n < 2 {
        return false;
    }
    if n % 2 == 0 {
        return n == 2;
    }
    if n % 3 == 0 {
        return n == 3;
    }
    let mut p = 5;
    while p * p <= n {
        if n % p == 0 {
            return false;
        }
        p += 2;
        if n % p == 0 {
            return false;
        }
        p += 4;
    }
    true
}

fn cycle(n: u32) -> u32 {
    let mut m: u32 = n;
    let mut p: u32 = 1;
    while m >= 10 {
        p *= 10;
        m /= 10;
    }
    m + 10 * (n % p)
}

fn is_circular_prime(p: u32) -> bool {
    if !is_prime(p) {
        return false;
    }
    let mut p2: u32 = cycle(p);
    while p2 != p {
        if p2 < p || !is_prime(p2) {
            return false;
        }
        p2 = cycle(p2);
    }
    true
}

fn test_repunit(digits: usize) {
    use rug::{integer::IsPrime, Integer};
    let repunit = "1".repeat(digits);
    let bignum = Integer::from_str_radix(&repunit, 10).unwrap();
    if bignum.is_probably_prime(10) != IsPrime::No {
        println!("R({}) is probably prime.", digits);
    } else {
        println!("R({}) is not prime.", digits);
    }
}

fn main() {
    use rug::{integer::IsPrime, Integer};
    println!("First 19 circular primes:");
    let mut count = 0;
    let mut p: u32 = 2;
    while count < 19 {
        if is_circular_prime(p) {
            if count > 0 {
                print!(", ");
            }
            print!("{}", p);
            count += 1;
        }
        p += 1;
    }
    println!();
    println!("Next 4 circular primes:");
    let mut repunit: u32 = 1;
    let mut digits: usize = 1;
    while repunit < p {
        repunit = 10 * repunit + 1;
        digits += 1;
    }
    let mut bignum = Integer::from(repunit);
    count = 0;
    while count < 4 {
        if bignum.is_probably_prime(15) != IsPrime::No {
            if count > 0 {
                print!(", ");
            }
            print!("R({})", digits);
            count += 1;
        }
        digits += 1;
        bignum = bignum * 10 + 1;
    }
    println!();
    test_repunit(5003);
    test_repunit(9887);
    test_repunit(15073);
    test_repunit(25031);
    test_repunit(35317);
    test_repunit(49081);
}
