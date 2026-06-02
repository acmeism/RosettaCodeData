import "std/vec.zc"
import "std/sort.zc"

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

let asc_primes: Vec<int>;

fn generate(first: int, cand: int, digits: int) {
    if !digits {
        if is_prime(cand) && !asc_primes.contains(cand) { asc_primes << cand; }
        return;
    }
    for let i = first;  i <= 9; ++i  {
        let next = cand * 10 + i;
        generate(i + 1, next, digits - 1);
    }
}

fn main() {
    asc_primes = Vec<int>::new();
    for digits in 1..10 { generate(1, 0, digits); }
    let len = asc_primes.length();
    sort_int(asc_primes.data, len);
    println "There are {len} ascending primes, namely:";
    for i in 0..len {
        print "{asc_primes[i]:8d} ";
        if !((i + 1) % 10) { println ""; }
    }
    asc_primes.free();
}
