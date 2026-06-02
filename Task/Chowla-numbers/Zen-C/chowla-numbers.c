import "locale.h"

fn chowla(n: int) -> int {
    assert(n > 0, "argument must be a positive integer.");
    let sum = 0;
    for let i = 2; i * i <= n; ++i {
        if !(n % i) {
            let j = n / i;
            sum += (i == j) ? i : i + j;
        }
    }
    return sum;
}

fn sieve(c: bool*, limit: const int) {
    // True denotes composite, false denotes prime.
    // Only interested in odd numbers >= 3.
    for let i = 3; i * 3 < limit; i += 2 {
        if !c[i] && !chowla(i) {
            for let j = 3 * i; j < limit; j += 2 * i {
                c[j] = true;
            }
        }
    }
}

fn main() {
    setlocale(LC_NUMERIC, "");
    for let i = 1; i <= 37; ++i {
        println "chowla({i:2d}) = {chowla(i)}";
    }
    println "";
    let count = 1;
    let limit = 10_000_000;
    autofree let c = (bool*)calloc(limit, sizeof(bool));
    sieve(c, limit);
    let power = 100;
    for let i = 3; i < limit; i += 2 {
        if !c[i] { count++; }
        if i == power - 1 {
            println "Count of primes up to {power:'-10d} = {count:'d}";
            power *= 10;
        }
    }
    println "";
    count = 0;
    limit = 35_000_000;
    for let i = 2; ; ++i {
        let p = (1 << (i - 1)) * ((1 << i) - 1) // perfect numbers must be of this form
        if p > limit { break; }
        if chowla(p) == p - 1 {
            println "{p:'d} is a perfect number.";
            count++;
        }
    }
    println "\nThere are {count} perfect numbers <= 35,000,000.";
}
