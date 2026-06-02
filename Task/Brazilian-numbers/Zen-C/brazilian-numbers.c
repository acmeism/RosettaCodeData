import "locale.h"

fn same_digits(n: int, b: int) -> bool {
    let f = n % b;
    n /= b;
    while n > 0 {
        if n % b != f { return false; }
        n /= b;
    }
    return true;
}

fn is_brazilian(n: int) -> bool {
    if n < 7 { return false; }
    if !(n % 2) && n >= 8 { return true; }
    for b in 2..(n - 1) {
        if same_digits(n, b) { return true; }
    }
    return false;
}

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
    let kinds = [" ", " odd ", " prime "];
    for i, kind in kinds {
        println "First 20{kind}Brazilian numbers:";
        let c = 0;
        let n = 7;
        loop {
            if is_brazilian(n) {
                print "{n} ";
                if ++c == 20 {
                    let nl = i < 2 ? "\n" : "";
                    println "{nl}";
                    break;
                }
            }
            if kind == " " {
                n++;
            } else if kind == " odd " {
                n += 2;
            } else {
                loop {
                    n += 2;
                    if is_prime(n) { break; }
                }
            }
        }
    }
    let c = 0;
    let n = 7;
    while c < 100_000 {
        if is_brazilian(n) { c++; }
        n++;
    }
    println "The 100,000th Brazilian number: {n - 1:'d}";
}
