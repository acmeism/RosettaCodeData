import "locale.h"

fn digit_sum(n: u64) -> int {
    let sum: u64 = 0;
    while n > 0 {
        sum += n % 10;
        n /= 10;
    }
    return (int)sum;
}

fn digital_root(n: u64) -> (int, int) {
    if n < 10 { return ((int)n, 0); }
    let dr = n;
    let ap = 0;
    while dr > 9 {
        dr = digit_sum(dr);
        ap++;
    }
    return ((int)dr, ap);
}

fn main() {
    setlocale(LC_NUMERIC, "");
    let a: u64[8] = [1, 14, 267, 8128, 627615, 39390, 588225, 393900588225];
    for n in a {
        let (dr, ap) = digital_root(n);
        println "{n:'15lu} has additive persistence {ap} and digital root of {dr}";
    }
}
