fn is_prime(n: int) -> bool {
    if n < 2 { return false; }
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

fn reverse_digits(n: int) -> int {
    let r = 0;
    while n > 0 {
        r = r * 10 + n % 10;
        n /= 10;
    }
    return r;
}

fn main() {
    println "Primes under 500 which are also primes when the digits are reversed:";
    print "  2 ";
    let count = 1;
    let i = 3;
    while i < 500 {
        if is_prime(i) && is_prime(reverse_digits(i)) {
            print "{i:3d} ";
            if !(++count % 15) { println ""; }
        }
        i += 2;
    }
    println "\n\n{count} such primes found.";
}
