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
    let count = 0;
    let n = 1;
    setlocale(LC_NUMERIC, "en_US.UTF-8");
    println "First 50 numbers which are the cube roots of the products of their proper divisors:";
    loop {
        let dc = divisor_count(n);
        if n == 1 || dc  == 8 {
            if ++count <= 50 {
                print "{n:3d} ";
                if !(count % 10) { println ""; }
            } else if count == 500 {
                println "\n500th    : {n:'7d}";
            } else if count == 5_000 {
                println "\n5,000th  : {n:'7d}";
            } else if count == 50_000 {
                println "\n50,000th : {n:'7d}";
                break;
            }
        }
        n++;
    }
}
