import "locale.h"

fn is_prime(n: u64) -> bool {
    if n < 2 { return false; }
    if n % 2 == 0 { return n == 2; }
    if n % 3 == 0 { return n == 3; }
    let d: u64 = 5;
    while d * d <= n {
        if n % d == 0 { return false; }
        d += 2;
        if n % d == 0 { return false; }
        d += 4;
    }
    return true;
}

fn main() {
    let count = 0;
    setlocale(LC_NUMERIC, "en_US.UTF-8");
    for let i: u64 = 42; count < 42; i++ {
    if is_prime(i) {
        count++;
        println "{count:2d}: {i:'18lu}";
        i = 2 * i - 1;
    }
}
