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

fn pascal_triangle(n: uint) {
    if n < 1 { return; }
    for i in 0..n {
        for _ in 1..(n - i) { print "   "; }
        for j in 0..=i {
            print "{binomial(i, j):3lu}   ";
        }
        println "";
    }
}

fn main() {
    pascal_triangle(13);
}
