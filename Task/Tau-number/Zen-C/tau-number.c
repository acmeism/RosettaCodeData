import "locale.h"

fn divisor_count(n: int) -> int {
    let i = 1;
    let k = (n % 2 == 0) ? 1 : 2;
    let count = 0;
    while i * i <= n {
        if n % i == 0 {
            count++;
            let j = n / i;
            if j != i { count++; }
        }
        i += k;
    }
    return count;
}

fn main() {
    setlocale(LC_NUMERIC, "en_US.UTF-8");
    println "The first 100 Tau numbers are:";
    let count = 0;
    for let i = 1; count < 100; ++i {
        if !(i % divisor_count(i)) {
            print "{i:'5d}  ";
            if !(++count % 10) { println ""; }
        }
    }
}
