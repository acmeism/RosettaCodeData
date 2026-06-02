import "std/math.zc"

fn a_mean(a: f64*, len: const usize) -> f64 {
    let sum = 0.0;
    for i in 0..len { sum += a[i]; }
    return sum / (f64)len;
}

fn g_mean(a: f64*, len: const usize) -> f64 {
    let prod = 1.0;
    for i in 0..len { prod *= a[i]; }
    return Math::pow(prod, 1.0 / (f64)len);
}

fn h_mean(a: f64*, len: const usize) -> f64 {
    let sum = 0.0;
    for i in 0..len { sum += 1.0 / a[i]; }
    return 1.0 / sum * (f64)len;
}

fn main() {
    let a: f64[10];
    for i in 0..10 { a[i] = (f64)(i + 1); }
    let am = a_mean(a, 10);
    let gm = g_mean(a, 10);
    let hm = h_mean(a, 10);
    let cmp = (am >= gm && gm >= hm) ? "true" : "false";
    println "For the numbers 1 to 10:";
    println "  Arithmetic mean = {am:g}";
    println "  Geometric mean  = {gm:0.14f}";
    println "  Harmonic mean   = {hm:0.14f}";
    println "  A >= G >= H     = {cmp}";
}
