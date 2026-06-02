fn factorial(n: uint) -> u64 {
    let prod: u64 = 1;
    for i in 2..=n { prod *= i; }
    return prod;
}

fn binomial(n: uint, k: uint) -> u64 {
    assert(n >= k, "The second argument cannot be more than the first");
    if n == k { return 1; }
    let prod: u64 = 1;
    let i = n - k + 1;
    while i <= n { prod *= i++; }
    return prod / factorial(k);
}

fn main() {
    def LIMIT = 14;
    print "n/k |";
    for k in 0..=LIMIT { print "{k:5d}"; }
    println "";
    print "----+";
    for i in 0..=LIMIT{ print "-----"; }
    println "";
    for n in 0..=LIMIT {
        print "{n:3d} |";
        for k in 0..=n { print "{binomial(n, k):5lu}"; }
        println "";
    }
}
