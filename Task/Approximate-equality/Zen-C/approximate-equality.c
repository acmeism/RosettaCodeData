import "std/math.zc"

fn main() {
    let tol = 1.0e-16;
    let sqrt2 = Math::sqrt(2.0);
    let pairs: (f64, f64)[8] = [
        (100000000000000.01, 100000000000000.011),
        (100.01, 100.011),
        (10000000000000.001 / 10000.0, 1000000000.0000001000),
        (0.001, 0.0010000001),
        (0.000000000000000000000101, 0.0),
        (sqrt2 * sqrt2, 2.0),
        (-sqrt2 * sqrt2, -2.0),
        (3.14159265358979323846, 3.14159265358979324)
    ];
    println "Approximate equality of test cases for a tolerance of {tol:g}:";
    for i in 0..pairs.len {
        let (p0, p1) = pairs[i];
        let res: bool = Math::abs(p0 - p1) < tol;
        println "  {i + 1} -> {res}";
    }
}
