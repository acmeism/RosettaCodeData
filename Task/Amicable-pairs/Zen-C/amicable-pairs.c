fn proper_divisor_sum(n: int) -> int {
    let i = 1;
    let k = (n % 2 == 0) ? 1 : 2;
    let sum = 0;
    while i * i <= n {
        if n % i == 0 {
            sum += i;
            let j = n / i;
            if j != i { sum += j; }
        }
        i += k;
    }
    return sum - n;
}

fn main() {
    def LIMIT = 20_000;
    println "The amicable pairs below {LIMIT} are:";
    for m in 1..LIMIT {
        let n = proper_divisor_sum(m);
        if m < n && m == proper_divisor_sum(n) {
            println "  {m:5d} and {n:5d}";
        }
    }
}
