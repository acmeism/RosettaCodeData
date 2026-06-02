import "std/vec.zc"

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

fn count_factors(n: int) -> int {
    if n < 2 { return 0; }
    let factors = Vec<int>::new();
    let inc: int[8] = [4, 2, 4, 2, 4, 6, 2, 6];
    while n % 2 == 0 {
        factors << 2;
        n /= 2;
    }
    while n % 3 == 0 {
        factors << 3;
        n /= 3;
    }
    while n % 5 == 0 {
        factors << 5;
        n /= 5;
    }
    let k = 7;
    let i: usize = 0;
    while k * k <= n {
        if n % k == 0 {
            factors << k;
            n /= k;
        } else {
            k += inc[i];
            i = (i + 1) % 8;
        }
    }
    if n > 1 { factors << n; }
    return (int)factors.length();
}

fn is_attractive(n: int) -> bool {
    let c = count_factors(n);
    return is_prime(c);
}

fn main() {
    let lim: const int = 120;
    println "The attractive numbers up to and including {lim} are:";
    let count = 0;
    for i in 1..=lim {
        if is_attractive(i) {
            print "{i:4d}";
            if !(++count % 20) { println ""; }
        }
    }
    println "\n\n{count} such numbers found.";
}
