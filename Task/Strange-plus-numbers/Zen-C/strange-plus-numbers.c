import "std/vec.zc"

fn digits(n: int) -> Vec<int> {
    let digs = Vec<int>::new();
    if n == 0 {
        digs << 0;
        return digs;
    }
    while n > 0 {
        digs << (n % 10);
        n /= 10;
    }
    digs.reverse();
    return digs;
}

let primes: const int[7] = [2, 3, 5, 7, 11, 13, 17];

fn is_prime(n: int) -> bool {
    for p in primes { if n == p { return true; } }
    return false;
}

fn main() {
    println "Strange plus numbers between 101 and 499 inclusive:"
    let count = 0;
    for n in 101..500 {
        let d = digits(n);
        if is_prime(d[0] + d[1]) && is_prime(d[1] + d[2]) {
            print "{n} ";
            if !(++count % 10) { println ""; }
        }
    }
    println "\n\nFound {count} such numbers.";
}
