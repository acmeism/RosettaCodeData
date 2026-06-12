fn digit_sum(n: int) -> int {
    let sum: int = 0;
    while n > 0 {
        sum += n % 10;
        n /= 10;
    }
    return sum;
}

fn main() {
    println "Numbers under 1,000 whose sum of digits is a substring of themselves:"
    let count = 0;
    for n in 0..<1000 {
        let ns = "{n}";
        let ds = "{digit_sum(n)}";
        if strstr(ns, ds) {
            print "{n:3d} ";
            if ++count % 8 == 0 { println ""; }
        }
    }
    println "\n{count} such numbers found."
}
