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

fn main() {
    setlocale(LC_NUMERIC, "");
    println "Triplets of primes: (n - 1, n + 3, n + 5) where n < 6,000:";
    let count = 0;
    for n in 4..6000 step 2 {
        if is_prime(n - 1) && is_prime(n + 3) && is_prime(n + 5) {
            println "{n:'5d}  =>  {n - 1:'5d}  {n + 3:'5d}  {n + 5:'5d}";
            count++;
        }
    }
    println "\n{count} such triplets found.";
}
