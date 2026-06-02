import "std/math.zc"

fn rms(a: f64*, len: const int) -> f64 {
    let sum = 0.0;
    for i in 0..len { sum += a[i] * a[i]; }
    return Math::sqrt(sum / len);
}

fn main() {
    let a = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0];
    println "{rms(a, 10):0.16f}";
}
