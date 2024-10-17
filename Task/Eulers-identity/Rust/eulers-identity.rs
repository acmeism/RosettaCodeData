use std::f64::consts::PI;

extern crate num_complex;
use num_complex::Complex;

fn main() {
    println!("{:e}", Complex::new(0.0, PI).exp() + 1.0);
}
