import "std/vec.zc"
import "std/math.zc"

fn digits<T>(n: T) -> Vec<int> {
    let digs = Vec<int>::new();
    if n == 0 {
        digs << 0;
        return digs;
    }
    while n > 0 {
        digs << (n % 10);
        n /= 10;
    }
    digs.reverse();
    return digs;
}

fn is_square<T>(n: T) -> bool {
    let sqrt = (T)Math::round(Math::sqrt((f64)n));
    return sqrt * sqrt == n;
}

fn main() {
    println "The first 7 sub-unit squares are:";
    println "1";
    let count = 1;
    for let i: u64 = 2; count < 7; i++ {
        let sq = i * i;
        let digs = digits(sq);
        if digs[0] != 1 && !digs.contains(0) {
            let sum: u64 = digs[0] - 1;
            for j in 1..digs.length() { sum = sum * 10 + digs[j] - 1; }
            if is_square(sum) {
                println "{sq}";
                count++;
            }
        }
    }
}
