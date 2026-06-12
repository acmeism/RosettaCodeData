import "std/vec.zc"
import "std/math.zc"
import "locale.h"

fn prime_sieve(n: int) -> Vec<int> {
    let primes = Vec<int>::new();
    if n < 2 { return primes; }
    primes << 2;
    if n == 2 { return primes; }
    let k = (n - 3) / 2 + 1;
    autofree let marked = (bool*)malloc(k * sizeof(bool));
    for i in 0..k { marked[i] = true; }
    let limit = ((int)Math::sqrt((f64)n) - 3) / 2 + 1;
    if limit < 0 { limit = 0; }
    for i in 0..limit {
        if marked[i] {
            let p = 2 * i + 3;
            let s = (p * p - 3) / 2;
            while s < k {
                marked[s] = false;
                s += p;
            }
        }
    }
    for i in 0..k {
        if marked[i] { primes << (2 * i + 3); }
    }
    return primes;
}

fn digits(n: int) -> Vec<int> {
    let digs = Vec<int>::new();
    if n == 0 {
        digs << 0;
        return digs;
    }
    while n > 0 {
        digs << (n % 10);
        n /= 10;
    }
    digs.reverse();
    return digs;
}

fn main() {
    let limit = 999;
    let primes = prime_sieve(limit);
    let count = 0;
    println "Primes under 1,000 which contain only one odd digit:";
    for i in 1..primes.length() {
        let digs = digits(primes[i]);
        let all = true;
        for j in 0..(digs.length() - 1) {
            if digs[j] & 1 {
                all = false;
                break;
            }
        }
        if all {
            print "{primes[i]:3d} ";
            if !(++count % 9) { println ""; }
        }
    }
    println "\nFound {count} such primes.";

    limit = 999_999_999;
    primes.free();
    primes = prime_sieve(limit);
    count = 0;
    let pow = 10;
    setlocale(LC_NUMERIC, "");
    for i in 1..primes.length() {
        let digs = digits(primes[i]);
        let all = true;
        for j in 0..(digs.length() - 1) {
            if digs[j] & 1 {
                all = false;
                break;
            }
        }
        if all { count++; }
        if primes[i] > pow {
            println "There are {count:'7d} such primes under {pow:'d}";
            pow *= 10;
        }
    }
    println "There are {count:'7d} such primes under {pow:'d}";
}
