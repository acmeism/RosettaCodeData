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
    def LIMIT = 22;
    let numbers: [int; LIMIT];
    for let i = 1; ; ++i {
        let nd = divisor_count(i);
        if nd <= LIMIT && !numbers[nd - 1] {
            numbers[nd - 1] = i;
            let all = true;
            for n in numbers {
                if n <= 0 {
                    all = false;
                    break;
                }
            }
            if all { break; }
        }
    }
    println "The first {LIMIT} terms are:";
    print "[";
    for i in 0..LIMIT { print "{numbers[i]}, "; }
    println "\b\b]";
}
