import "std/vec.zc"

fn sieve_of_eratosthenes(n: int) -> Vec<int> {
    let primes = Vec<int>::new();
    if n < 2 { return primes; }
    autofree let comp = (bool*)calloc(n - 1, sizeof(bool));
    let p = 2;
    loop {
        let p2 = p * p;
        if p2 > n { break; }
        let i = p2;
        while i <= n {
            comp[i - 2] = true;
            i += p;
        }
        loop {
            p++;
            if !comp[p - 2] { break; }
        }
    }
    for i in 0..(n - 1) {
        if !comp[i] { primes << (i + 2); }
    }
    return primes;
}

fn main() {
    println "Primes less than 100:";
    let primes = sieve_of_eratosthenes(100);
    for p in primes { print "{p} "; }
    println "";
}
