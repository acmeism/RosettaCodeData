import "std/math.zc"

fn agm(a: f64, g: f64) -> f64 {
    let eps: const f64 = 1e-14;
    while Math::abs(a - g) > Math::abs(a) * eps {
        let t = a;
        a = (a + g) / 2.0;
        g = Math::sqrt(t * g);
    }
    return a;
}

fn main() {
    let a = agm(1.0, 1.0 / Math::sqrt(2.0));
    println "{a:0.16f}";
}
