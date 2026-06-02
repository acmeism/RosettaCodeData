import "std/vec.zc"
import "std/math.zc"

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

let all_primes: Vec<int>;
let found_combo = false;

fn find_combo(k: int, x: int, m: int, n: int, combo: int*, len: const usize) {
    if k >= m {
        let sum = 0;
        for i in 0..len { sum += all_primes[combo[i]]; }
        if sum == x {
            let s = (m > 1) ? "s" : " ";
            print "Partitioned {x:5d} with {m:2d} prime{s}: ";
            for i in 0..m {
                print "{all_primes[combo[i]]}";
                let t = (i < m - 1) ? "+" : "\n";
                print "{t}";
            }
            found_combo = true;
        }
    } else {
        for j in 0..n {
            if k == 0 || j > combo[k - 1] {
                combo[k] = j;
                if !found_combo { find_combo(k + 1, x, m, n, combo, len); }
            }
        }
    }
}

fn partition(x: int, m: int) {
    if (x < 2 || m < 1 || m >= x) {
        eprintln "Invalid argument(s).";
        return;
    }
    let n = 0;
    for p in all_primes {
        if p <= x {
            n++;
        } else {
            break;
        }
    }
    if n < m {
        eprintln "Not enough primes.";
        return;
    }
    autofree let combo = (int*)calloc(m, sizeof(int));
    found_combo = false;
    find_combo(0,  x,  m, n, combo, m);
    if !found_combo {
        let s = (m > 1) ? "s" : " ";
        println "Partitioned {x:5d} with {m:2d} prime{s}: (not possible)";
    }
}

fn main() {
    all_primes = prime_sieve(100_000);
    let a: int[10][2] = [
        [99809, 1],
        [18, 2],
        [19, 3],
        [20, 4],
        [2017, 24],
        [22699, 1],
        [22699, 2],
        [22699, 3],
        [22699, 4],
        [40355, 3]
    ];
    for i in 0..a.len { partition(a[i][0], a[i][1]); }
    all_primes.free();
}
