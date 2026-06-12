import "std/vec.zc"
import "locale.h"

fn is_prime(n: int) -> bool {
    if n < 2 { return false; }
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
    let pows2: [int; 20];
    for i in 0..20 { pows2[i] = (1 << i); }
    let dp = Vec<int>::new();
    dp << 1;
    let dp1000: int;
    let dp10000: int;
    let count = 1;
    for let n = 3; count < 10000; n += 2 {
        let found = false;
        for p in pows2 {
            if p > n { break; }
            if is_prime(n - p) {
                found = true;
                break;
            }
        }
        if !found {
            if ++count <= 50 {
                dp << n;
            } else if count == 1000 {
                dp1000 = n;
            } else if count == 10000 {
                dp10000 = n;
            }
        }
    }
    setlocale(LC_NUMERIC, "");
    println "First 50 De Polignac numbers:";
    for i in 0..dp.length() {
        print "{dp[i]:'5d} ";
        if !((i + 1) % 10) { println ""; }
    }
    println "\nOne thousandth: {dp1000:'d}";
    println "\nTen thousandth: {dp10000:'d}";
}
