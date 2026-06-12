import "std/math.zc"

fn low_square_start_n(n: u64) -> u64 {
    let sqrt_n = Math::sqrt((f64)n);
    let sqrt_n10 = Math::sqrt((f64)(n * 10));
    let pow10: u64 = 1;
    loop {
        let sqrts: u64[2] = [(u64)sqrt_n, (u64)sqrt_n10];
        for i in sqrts {
            let ii = i;
            for _ in 0..2 {
                let my_sqr = ii * ii / pow10;
                if my_sqr == n { return ii; }
                ii++;
            }
            pow10 *= 10;
        }
        sqrt_n *= 10.0;
        sqrt_n10 *= 10.0;
        if sqrt_n > (10.0 * n) { break; }
    }
}

fn main() {
    println "Test 1 .. 49";
    for let i: u64 = 1; i < 50; ++i {
        let t = low_square_start_n(i);
        print "{t * t:7lu}";
        if !(i % 10) { println ""; }
    }
    println "\n";
    println "Test 999,991 .. 1,000,000";
    for let i: u64 = 999_991; i <= 1_000_000; ++i {
        let t = low_square_start_n(i);
        println "{i:10lu} : {t:10lu} -> {t * t:14lu}";
    }
}
