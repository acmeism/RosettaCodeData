import "std/math.zc"
import "locale.h"

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

fn next_prime(n: int) -> int {
    if n < 2 { return 2; }
    n = !(n % 2) ? n + 1 : n + 2;
    loop {
        if is_prime(n) { return n; }
        n += 2;
    }
}

fn is_square(n: int) -> (bool, int) {
    let sqrt = (int)Math::sqrt((f64)n);
    if sqrt * sqrt == n { return (true, sqrt) };
    return (false, sqrt);
}

fn main() {
    setlocale(LC_NUMERIC, "");
    def LIM = 10_000_000;
    let p1 = 3;
    let count = 0;
    loop {
        let p2 = next_prime(p1);
        if p2 >= LIM { break; }
        if p2 == p1 + 2 {
            let sum = p1 + p2;
            let (is_sq, sqrt) = is_square(sum);
            if is_sq {
                printf("%'9d + %'9d = %'10d = %'5d²\n", p1, p2, sum, sqrt);
                count++;
            }
        }
        p1 = p2;
    }
    println "\nFound {count} twin primes < {LIM:'d} whose sum is a square number.";
}
