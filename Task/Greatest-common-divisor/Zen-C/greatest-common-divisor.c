fn gcd(x: int, y: int) -> int {
    while y {
        let t = y;
        y = x % y;
        x = t;
    }
    return abs(x);
}

fn main() {
    println "gcd(33, 77) = {gcd(33, 77)}";
    println "gcd(49865, 69811) = {gcd(49865, 69811)}";
}
