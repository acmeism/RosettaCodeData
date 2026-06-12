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
    let sum = 0;
    let i = 1;
    println " i   p[i]  Σp[i]";
    println "----------------";
    let p = 2;
    while p < 1000 {
        if is_prime(p) {
            if i % 2 {
                sum += p;
                if is_prime(sum) {
                    printf("%3d  %3d  %'6d\n", i , p, sum);
                }
            }
            i++;
        }
        p = p > 2 ? p + 2 : p + 1;
    }
}
