#![feature(zero_one)] // <-- unstable feature
use std::ops::{Add, Mul};
use std::num::Zero;

fn dot_product<T1, T2, U, I1, I2>(lhs: I1, rhs: I2) -> Option<U>
    where T1: Mul<T2, Output = U>,
          U: Add<U, Output = U> + Zero,
          I1: IntoIterator<Item = T1>,
          I2: IntoIterator<Item = T2>,
          I1::IntoIter: ExactSizeIterator,
          I2::IntoIter: ExactSizeIterator,
{
    let (iter_lhs, iter_rhs) = (lhs.into_iter(), rhs.into_iter());
    match (iter_lhs.len(), iter_rhs.len()) {
        (0, _) | (_, 0) => None,
        (a,b) if a != b => None,
        (_,_) => Some( iter_lhs.zip(iter_rhs)
           .fold(U::zero(), |sum, (a, b)| sum + (a * b)) )
    }
}



fn main() {
    let v1 = vec![1, 3, -5];
    let v2 = vec![4, -2, -1];

    println!("{}", dot_product(&v1, &v2).unwrap());
}
