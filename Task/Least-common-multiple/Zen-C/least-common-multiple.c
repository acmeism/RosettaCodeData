fn gcd(x: int, y: int) -> int {
    while y {
        let t = y;
        y = x % y;
        x = t;
    }
    return abs(x);
}

fn lcm(x: int, y: int) -> int {
    if !x && !y { return 0; }
    return abs(x * y) / gcd(x, y);
}

fn main() {
    println "lcm(12, 18) = {lcm(12, 18)}";
    println "lcm(-6, 14) = {lcm(-6, 14)}";
    println "lcm(35,  0) = {lcm(35,  0)}";
}
