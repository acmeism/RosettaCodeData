fn is_prime(n: int) -> bool {
    if n < 2 { return false; }
    if n % 2 == 0 { return n == 2; }
    for let p = 3; p * p <= n; p += 2 {
        if n % p == 0 { return false; }
    }
    return true;
}

fn main() {
    let tests = [2, 5, 12, 19, 57, 61, 97];
    println "Are the following prime?";
    for t in tests {
        println "{t:2d} -> {is_prime(t)}";
    }
}
