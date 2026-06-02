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
    println "The number of divisors for the first 100 positive integers is:";
    for i in 1..=100 {
        print "{divisor_count(i):3d} ";
        if !(i % 10) { println ""; }
    }
}
