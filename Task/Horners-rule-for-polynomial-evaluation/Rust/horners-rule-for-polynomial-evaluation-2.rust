extern crate num; // 0.2.0
use num::Zero;
use std::ops::{Add, Mul};

fn horner<Arr, Arg, Out>(v: &[Arr], x: Arg) -> Out
where
    Arr: Clone,
    Arg: Clone,
    Out: Zero + Mul<Arg, Output = Out> + Add<Arr, Output = Out>,
{
    v.iter()
        .rev()
        .fold(Zero::zero(), |acc, coeff| acc * x.clone() + coeff.clone())
}

fn main() {
    let v = [-19., 7., -4., 6.];
    let output: f64 = horner(&v, 3.0);
    println!("result: {}", output);
}
