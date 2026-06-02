import "std/vec.zc"
import "std/string.zc"
import "locale.h"

let factorials: u64[19] = [1, 1];

fn cache_factorials() {
    let fact: u64 = 1;
    for i in 2..19 {
        fact *= i;
        factorials[i] = fact;
    }
}

fn find_nearest_fact(n: u64) -> int {
    for i in 1..19 {
        if factorials[i] >= n { return i; }
    }
    return 18;
}

fn find_nearest_in_vec(a: Vec<u64>*, n: u64) -> u64 {
    let l: usize = 0;
    let r = a.length();
    let m: usize;
    while l < r {
        m = (l + r) / 2;
        if a.get(m) > n {
            r = m;
        } else {
            l = m + 1;
        }
    }
    if r > 0 && a.get(r - 1) == n { return r - 1; }
    return r;
}

fn jordan_polya(limit: u64) -> Vec<u64> {
    let res = Vec<u64>::new();
    let ix = find_nearest_fact(limit);
    let t: u64;
    for i in 0..=ix {
        t = factorials[i];
        res << t;
    }
    let k: usize = 2;
    let p: u64;
    let rk: u64;
    let kl: u64;
    while k < res.length() {
        rk = res[k];
        for let l: usize = 2; l < res.length(); ++l {
            t = res[l];
            if t > limit / rk { break; }
            kl = t * rk;
            loop {
                p = find_nearest_in_vec(&res, kl);
                if p < res.length() && res[p] != kl {
                    res.insert(p, kl);
                } else if p == res.length() {
                    res << kl;
                }
                if kl > limit / rk { break; }
                kl *= rk;
            }
        }
        ++k;
    }
    res.remove(0);
    return res;
}

fn decompose(n: u64, start: u64) -> Vec<u64> {
    for let s: u64 = start; s > 0; --s {
        let f = Vec<u64>::new();
        if s < 2 { return f; }
        let m = n;
        while !(m % factorials[s]) {
            f << s;
            m /= factorials[s];
            if m == 1 { return f; }
        }
        if f.length() > 0 {
            let g = decompose(m, s - 1);
            if g.length() > 0 {
                let prod: u64 = 1;
                for let i: usize = 0; i < g.length(); ++i {
                    prod *= factorials[g[i]];
                }
                if prod == m {
                    for let i: usize = 0; i < g.length(); ++i {
                        let t = g[i];
                        f << t;
                    }
                    return f;
                }
            }
        }
    }
}

fn superscript(n: int) -> String {
    let ss: string[10] = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"];
    if n < 10 { return String::from(ss[n]); }
    let buf = String::from("");
    buf.append_c(ss[n / 10]);
    buf.append_c(ss[n % 10]);
    return buf;
}

fn main() {
    cache_factorials();
    let v = jordan_polya((u64)1 << 53);
    println "First 50 Jordan-Pólya numbers:";
    for i in 0..50 {
        print "{v[i]:4lu} ";
        if !((i + 1) % 10) { println ""; }
    }

    printf("\nThe largest Jordan-Pólya number before 100 million: ");
    setlocale(LC_NUMERIC, "");
    let ix = find_nearest_in_vec(&v, (u64)100_000_000);
    println "{v[ix - 1]:'lu}\n\n";

    let targets: u64[5] = [800, 1050, 1800, 2800, 3800];
    let t: u64;
    for let i = 0; i < 5; ++i {
        t = v[targets[i] - 1];
        println "The {targets[i]:'lu}th Jordan-Pólya number is : {t:'lu}";
        let w = decompose(t, 18);
        let count = 1;
        t = w[0];
        print " = ";
        for let j: usize = 1; j < w.length(); ++j {
            let u = w[j];
            if u != t {
                if count == 1 {
                    print "{t}! x ";
                } else {
                    let ss = superscript(count);
                    print "({t}!){ss} x ";
                    count = 1;
                }
                t = u;
            } else {
                ++count;
            }
        }
        if count == 1 {
            print "{t}! x ";
        } else {
            let ss = superscript(count);
            print "({t}!){ss} x ";
        }
        print "\b\b \n\n";
    }
}
