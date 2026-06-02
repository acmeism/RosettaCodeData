import "std/vec.zc"

fn k_prime(n: int, k: int) -> bool {
    let nf = 0;
    for i in 2..=n {
        while !(n % i) {
            if nf++ == k { return false; }
            n /= i;
        }
    }
    return nf == k;
}

fn gen(k: int, n: int) -> Vec<int> {
    let r = Vec<int>::new();
    let len = n;
    n = 2;
    for _ in 0..len {
        while !k_prime(n, k) { n++; }
        r << n++;
    }
    return r;
}

fn main() {
    for i in 1..6 {
        print "{i} [";
        let res = gen(i, 10);
        for j in res { print "{j}, "; }
        println "\b\b]";
    }
}
