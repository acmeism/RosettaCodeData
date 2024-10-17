/// Return whether the two numbers `a` and `b` are close.
/// Closeness is determined by the `epsilon` parameter -
/// the numbers are considered close if the difference between them
/// is no more than epsilon * max(abs(a), abs(b)).
fn isclose(a: f64, b: f64, epsilon: f64) -> bool {
    (a - b).abs() <= a.abs().max(b.abs()) * epsilon
}

fn main() {
    fn sqrt(x: f64) -> f64 { x.sqrt() }
    macro_rules! test {
        ($a: expr, $b: expr) => {
            let operator = if isclose($a, $b, 1.0e-9) { '≈' } else { '≉' };
            println!("{:>28} {} {}", stringify!($a), operator, stringify!($b))
        }
    }

    test!(100000000000000.01, 100000000000000.011);
    test!(100.01, 100.011);
    test!(10000000000000.001/10000.0, 1000000000.0000001000);
    test!(0.001, 0.0010000001);
    test!(0.000000000000000000000101, 0.0);
    test!( sqrt(2.0) * sqrt(2.0), 2.0);
    test!(-sqrt(2.0) * sqrt(2.0), -2.0);
    test!(3.14159265358979323846, 3.14159265358979324);
}
