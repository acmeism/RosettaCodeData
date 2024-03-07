use std::f64::consts;

fn main() {
    let gamma = |x: f64| { assert_ne!(x, 0.0); (2.0*consts::PI/x).sqrt() * (x * (x/consts::E).ln()).exp()};
    (1..=20).for_each(|x| {
        let x = f64::from(x) / 10.0;
        println!("{:.02} => {:.10}", x, gamma(x));
    });
}
