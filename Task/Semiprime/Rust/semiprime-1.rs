extern crate primal;

fn isqrt(n: usize) -> usize {
    (n as f64).sqrt() as usize
}

fn is_semiprime(mut n: usize) -> bool {
    let root = isqrt(n) + 1;
    let primes1 = primal::Sieve::new(root);
    let mut count = 0;

    for i in primes1.primes_from(2).take_while(|&x| x < root) {
        while n % i == 0 {
            n /= i;
            count += 1;
        }
        if n == 1 {
            break;
        }
    }

    if n != 1 {
        count += 1;
    }
    count == 2
}

#[test]
fn test1() {
    assert_eq!((2..10).filter(|&n| is_semiprime(n)).count(), 3);
}

#[test]
fn test2() {
    assert_eq!((2..100).filter(|&n| is_semiprime(n)).count(), 34);
}

#[test]
fn test3() {
    assert_eq!((2..1_000).filter(|&n| is_semiprime(n)).count(), 299);
}

#[test]
fn test4() {
    assert_eq!((2..10_000).filter(|&n| is_semiprime(n)).count(), 2_625);
}

#[test]
fn test5() {
    assert_eq!((2..100_000).filter(|&n| is_semiprime(n)).count(), 23_378);
}

#[test]
fn test6() {
    assert_eq!((2..1_000_000).filter(|&n| is_semiprime(n)).count(), 210_035);
}
