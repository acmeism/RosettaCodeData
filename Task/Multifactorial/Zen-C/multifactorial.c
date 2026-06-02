fn mf(n: int, d: int) -> int {
    let prod  = 1;
    while n > 1 {
        prod *= n;
        n -= d;
    }
    return prod;
}

fn main() {
    for d in 1..=5 {
        print "degree {d}: ";
        for n in 1..=10 { print "{mf(n, d):8d}"; }
        println "";
    }
}
