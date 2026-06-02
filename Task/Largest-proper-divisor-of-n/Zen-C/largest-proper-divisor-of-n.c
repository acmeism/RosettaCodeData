fn lpd(n: int) -> int {
    if n == 1 { return 1; }
    let lim = (n % 2) ? n / 3: n / 2;
    for i in lim..=1 step -1 {
        if !(n % i) { return i; }
    }
}

fn main() {
    println "Largest proper divisor of n where 1 <= n <= 100:";
    for n in 1..101 {
        print "{lpd(n):2d}  ";
        if !(n % 10) { println ""; }
    }
}
