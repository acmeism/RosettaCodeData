import "std/math.zc"

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
    let limit: const int = (int)Math::sqrt(1000.0);
    let i = 1;
    let count = 0;
    println "Square numbers 'n' where 'n + 1' is prime: ";
    while i <= limit {
        let n = i * i;
        if is_prime(n + 1) {
            print "{n}, ";
            count++;
        }
        i = (i == 1) ? 2 : i + 2;
    }
    println "\b\b \n\nFound {count} such numbers."
}
