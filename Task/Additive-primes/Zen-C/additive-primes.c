fn digit_sum(n: int) -> int {
    let sum = 0;
    while n > 0 {
        sum += n % 10;
        n /= 10;
    }
    return sum;
}

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
    println "Additive primes less than 500:";
    let i = 2;
    let count = 0;
    while i < 500 {
        if is_prime(i) && is_prime(digit_sum(i)) {
            print "{i:3d}  ";
            if !(++count % 10) { println ""; }
        }
        i = (i > 2) ? i + 2 : 3;
    }
    println "\n\n{count} such primes found.";
}
