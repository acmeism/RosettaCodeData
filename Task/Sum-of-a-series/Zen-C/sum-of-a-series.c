import "std/math.zc";

fn sum_series(n: int) -> f64 {
    let sum = 0.0;
    for i in 1..=n { sum += 1.0 / (f64)(i * i); }
    return sum;
}

fn main() {
    println "s(1000) = {sum_series(1000):0.16f}";
    let zeta2 = Math::PI() * Math::PI() / 6.0;
    println "zeta(2) = {zeta2:0.16f}";
}
