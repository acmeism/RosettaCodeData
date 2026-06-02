import "locale.h"

fn digits_sum(n: int) -> int {
    let sum = 0;
    while n > 0 {
        sum += n % 10;
        n /= 10;
    }
    return sum;
}

fn main() {
    setlocale(LC_NUMERIC, "");
    for n in 1..=70 {
        let m = 1;
        while digits_sum(m * n) != n { m++; }
        print "{m:'10d} ";
        if !(n % 10) { println ""; }
    }
}
