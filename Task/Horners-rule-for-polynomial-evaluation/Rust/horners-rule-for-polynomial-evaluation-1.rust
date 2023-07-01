fn horner(v: &[f64], x: f64) -> f64 {
    v.iter().rev().fold(0.0, |acc, coeff| acc*x + coeff)
}

fn main() {
    let v = [-19., 7., -4., 6.];
    println!("result: {}", horner(&v, 3.0));
}
