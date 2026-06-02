fn divisor_count(n: int) -> int {
    let i = 1;
    let k = (n % 2 == 0) ? 1 : 2;
    let count = 0;
    while i * i <= n {
        if n % i == 0 {
            count++;
            let j = n / i;
            if j != i { count++; }
        }
        i += k;
    }
    return count;
}

fn main() {
    println "The first 20 anti-primes are:";
    let max_div = 0;
    let count = 0;
    for let n = 1; count < 20; ++n {
        let d = divisor_count(n);
        if d > max_div {
            print "{n} ";
            max_div = d;
            count++;
        }
    }
    println "";
}
