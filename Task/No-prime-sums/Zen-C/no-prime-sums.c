import "std/vec.zc"
import "std/math.zc"

let nc: bool*;

fn not_comp_sieve(n: int) {
    let primes = Vec<int>::new();
    if n < 2 { return; }
    primes << 2;
    if n == 2 { return; }
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
    for p in primes { nc[p] = true; }
}

def BOTH = 0;
def ODD  = 1;
def EVEN = 2;

let kinds = ["", "odd ", "even "];

fn no_prime_sums(start: int, limit: int, kind: int) -> Vec<int> {
    let step = (kind == BOTH) ? 1 : 2;
    let k = (kind == EVEN) ? 2 : 3;
    let sums = Vec<int>::new();
    sums << 0;
    if start > 0 { sums << start;}
    let res = Vec<int>::new();
    res << start;
    while res.length() < limit {
        loop {
            let any = false;
            for s in sums {
                if nc[k + s] {
                    any = true;
                    break;
                }
            }
            if any { k += step; } else { break; }
        }
        if kind == BOTH || kind == ODD  && k % 2 == 1 || kind == EVEN && k % 2 == 0 {
            let extra = Vec<int>::new();
            for s in sums { extra << (k + s); }
            for e in extra { !sums.contains(e) { sums << e; } }
            res << k;
        }
        k += step;
    }
    return res;
}

fn main() {
    def N = 100_000_000;
    nc = (bool*)calloc(N + 1, sizeof(bool));
    not_comp_sieve(N);
    def LIMIT = 10;
    println "Sequence, starting with 1, then:";
    for kind in 0..3 {
        println "\nlexicographically earliest {kinds[kind]} integer such that no subsequence sums to a prime:";
        let nps = no_prime_sums(1, LIMIT, kind);
        print "[";
        for i in 0..nps.length() { print "{nps[i]}, "; }
        println "\b\b]";
    }
    free(nc);
}
