fn lshift(a: int*, n: const usize) {
    if n < 3 { return; }
    let first = a[0];
    for i in 0..n-1 { a[i] = a[i + 1]; }
    a[n - 1] = first;
}

fn main() {
    let a = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    print "Unshifted      : [";
    for i in 0..a.len { print "{a[i]}, " }
    println "\b\b]";
    for _ in 1..4 { lshift(a, a.len); }
    print "Shift left by 3: [";
    for i in 0..a.len { print "{a[i]}, " }
    println "\b\b]";
}
