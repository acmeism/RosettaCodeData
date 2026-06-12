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

fn digit_sum(n: int) -> int {
    let sum = 0;
    while n > 0 {
        sum += n % 10;
        n /= 10;
    }
    return sum;
}

fn main() {
    println "Nice primes in the open interval (500, 1000) are:";
    let c = 0;
    for i in 501..1000 step 2 {
        if is_prime(i) {
            let s = i;
            while s >= 10  { s = digit_sum(s); }
            if is_prime(s) { println "{++c:2d}: {i} -> Σ = {s}"; }
        }
    }
}
