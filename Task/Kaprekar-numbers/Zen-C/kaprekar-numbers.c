import "std/string.zc"

fn kaprekar(n: u64, base: u64) -> (bool, int) {
    if n == 1 { return (true, -1); }
    let order = 0;
    let nn = n * n;
    let power: u64 = 1;
    while power <= nn {
        power *= base;
        order++;
    }
    power /= base;
    order--;
    for ; power > 1; power /= base {
        let q = nn / power;
        let r = nn % power;
        if q >= n { return (false, -1); }
        if q + r == n { return (true, order); }
        order--;
    }
    return (false, -1);
}

let digits = "0123456789abcdefghijklmnopqrstuvwxyz";

fn atoi_b(s: string, base: u64) -> u64 {
    let res: u64 = 0;
    for i in 0..strlen(s) {
        let ix: u64 = strchr(digits, s[i]) - digits;
        res = res * base + ix;
    }
    return res;
}

fn itoa_b(n: u64, base: u64) -> String {
    if n == 0 { return String::from("0"); }
    let vr = Vec<rune>::new();
    while n > 0 {
        vr << digits[n % base];
        n /= base;
    }
    vr.reverse();
    return String::from_runes_vec(vr);
}

fn main() {
    let max: u64 = 10_000;
    println "Kaprekar numbers < {max}:";
    for let m: u64 = 0; m < max; ++m {
        if kaprekar(m, 10).v0 { println "  {m}"; }
    }

    // extra credit
    max = 1_000_000;
    let count = 0;
    for let m: u64 = 0; m < max; ++m {
        if kaprekar(m, 10).v0 { count++; }
    }
    println "\nThere are {count} Kaprekar numbers < {max}.";

    // extra extra credit
    let base: const int = 17;
    let max_b = "1000000";
    println "\nKaprekar numbers between 1 and {max_b} (base {base}):";
    max = atoi_b(max_b, base);
    println "\n Base 10  Base {base}        Square       Split";
    for let m: u64 = 2; m < max; ++m {
        let (is, pos) = kaprekar(m, base);
        if !is { continue; }
        let sq  = itoa_b(m * m, base);
        let str = itoa_b(m, base);
        let len = sq.length();
        let split = len - pos;
        let sub1 = sq.substring(0, split);
        let sub2 = sq.substring(split, len - split);
        println "{m:8lu}  {str.c_str():7s}  {sq.c_str():12s}  {sub1.c_str():6s} + {sub2}";
    }
}
