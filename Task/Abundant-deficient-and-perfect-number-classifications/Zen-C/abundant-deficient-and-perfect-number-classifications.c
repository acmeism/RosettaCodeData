import "locale.h"

fn proper_divisor_sum(n: int) -> int {
    let i = 1;
    let k = (n % 2 == 0) ? 1 : 2;
    let sum = 0;
    while i * i <= n {
        if n % i == 0 {
            sum += i;
            let j = n / i;
            if j != i { sum += j; }
        }
        i += k;
    }
    return sum - n;
}

fn main() {
    def LIMIT = 20_000;
    let d = 0;
    let a = 0;
    let p = 0;
    for i in 1..=LIMIT {
        let j = proper_divisor_sum(i);
        if j < i {
            d++;
        } else if j == i {
            p++;
        } else {
            a++;
        }
    }
    setlocale(LC_NUMERIC, "");
    println "Between  1 and {LIMIT:'d} there are:";
    println "  {d:'6d} deficient numbers";
    println "  {a:'6d} abundant numbers";
    println "  {p:'6d} perfect numbers";
}
