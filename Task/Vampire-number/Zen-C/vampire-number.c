import "std/vec.zc"
import "std/math.zc"

fn max(a: u64, b: u64) -> u64 {
    if a > b { return a; }
    return b;
}

fn min(a: u64, b: u64) -> u64 {
    if a < b { return a; }
    return b;
}

fn ndigits(x: u64) -> int {
    let n = 0 ;
    for ; x > 0; x /= 10 { n++; }
    return n;
}

fn dtally(x: u64) -> u64 {
    let t: u64 = 0;
    for ; x > 0; x /= 10 {
        t += 1 << ((x % 10) * 6);
    }
    return t;
}

let tens: [u64; 20];

fn init() {
    tens[0] = 1;
    for i in 1..20 { tens[i] = tens[i - 1] * 10; }
}

fn fangs(x: u64) -> Vec<u64> {
    let f = Vec<u64>::new();
    let nd = ndigits(x);
    if nd % 2 { return f; }
    nd /= 2;
    let lo = max(tens[nd - 1], (x + tens[nd] - 2) / (tens[nd] - 1));
    let hi = min(x / lo, (u64)Math::sqrt((f64)x));
    let t = dtally(x);
    for let a = lo; a <= hi; ++a {
        let b = x / a;
        if a * b == x &&
           (a % 10 > 0 || b % 10 > 0) &&
           t == dtally(a) + dtally(b) { f << a; }
    }
    return f;
}

fn show_fangs(x: u64, f: Vec<u64>*) {
    print "{x}";
    if f.length() > 1 { println ""; }
    for a in *f {
        println " = {a} x {x / a}";
    }
}

fn main() {
    init();
    let n = 0;
    for let x: u64 = 1; n < 26; ++x {
        let f = fangs(x);
        if f.length() > 0 {
            n++;
            print "{n:2d}: ";
            show_fangs(x, &f);
        }
    }
    println "";
    let nums: u64[3] = [16758243290880, 24959017348650, 14593825548650];
    for x in nums {
        let f = fangs(x);
        if f.length() > 0 {
            show_fangs(x, &f);
        } else {
            println "{x} is not vampiric";
        }
    }
}
