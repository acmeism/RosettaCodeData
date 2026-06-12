fn is_prime(n: int) -> bool {
    if n < 2      { return false; }
    if n % 2 == 0 { return n == 2; }
    if n % 3 == 0 { return n == 3; }
    let d = 5;
    while d * d <= n {
        if n % d == 0 { return false; }
        d += 2;
        if n % d == 0 { return false; }
        d += 4;
    }
    return true;
}

fn main() {
    println "pi(n), the number of primes <= n, where n >= 1 and pi(n) < 22:";
    let n = 1;
    let count = 0;
    while count < 22 {
        print "{count:2d}  ";
        if !(n++ % 10) { println ""; }
        if is_prime(n) { count++; }
    }
    println "";
}
