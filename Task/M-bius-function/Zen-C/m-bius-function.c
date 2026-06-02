import "std/vec.zc"

fn prime_factors(n: int) -> Vec<int> {
    let factors = Vec<int>::new();
    if n < 2 { return factors; }
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
    return factors;
}

fn is_square_free(n: int) -> bool {
    let i = 2;
    let s: int;
    while (s = i * i) <= n {
        if n % s == 0 { return false; }
        i += (i > 2) ? 2 : 1;
    }
    return true;
}

fn mu(n: int) -> int {
    assert(n >= 1, "Argument must be a positive integer.");
    if n == 1 { return 1; }
    let sqfree = is_square_free(n);
    let factors = prime_factors(n);
    if sqfree && (factors.length() % 2 == 0) { return 1; }
    if sqfree { return -1; }
    return 0;
}

fn main() {
    println "The first 199 Möbius numbers are:";
    for i in 0..10 {
        for j in 0..20 {
            if i == 0 && j == 0 {
                print "    ";
            } else {
                print "{mu(i * 20 + j): 3d} ";
            }
        }
        println "";
    }
}
