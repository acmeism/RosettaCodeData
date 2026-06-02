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

fn reverse_digits(n: int) -> int {
    let r = 0;
    while n > 0 {
        r = r * 10 + n % 10;
        n /= 10;
    }
    return r;
}

fn is_emirp(n: int) -> bool {
    if is_prime(n) {
        let r = reverse_digits(n);
        if r != n && is_prime(r) { return true; }
    }
    return false;
}

fn main() {
    setlocale(LC_NUMERIC, "en_US.UTF-8");
    println "The first 20 emirps are:";
    let count = 0;
    let i = 3;
    while count < 20 {
        if is_emirp(i) {
            print "{i:3d} ";
            if !(++count % 10) { println ""; }
        }
        i += 2;
    }

    println "\nThe emirps between 7,700 and 8,000 are:";
    count = 0;
    i = 7701;
    while i < 8000 {
        if is_emirp(i) {
            print "{i:'4d} ";
            if !(++count % 7) { println ""; }
        }
        i += 2;
    }

    print "\n\nThe 10,000th emirp is ";
    count = 0;
    i = 1;
    while count < 10000 {
        i += 2;
        if is_emirp(i) { count++; }
    }
    println "{i:'d}.";
}
