import "std/math.zc"

fn is_perfect(n: int) -> bool {
    if n <= 2 { return false; }
    let tot = 1;
    for i in 2..=Math::floor(Math::sqrt((f64)n)) {
        if n % i == 0 {
            tot += i;
            let q = n / i;
            if q > i { tot += q; }
        }
    }
    return n == tot;
}

fn main() {
    println "The first four perfect numbers are:";
    let count = 0;
    let i = 2;
    while count < 4 {
        if is_perfect(i) {
            println "{i} ";
            count++;
        }
        i += 2;  // there are no known odd perfect numbers
    }
}
