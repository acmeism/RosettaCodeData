use std::f64::INFINITY;
use std::ops::{Add, Mul};

#[derive(Clone, Copy, Debug, PartialEq)]
struct MaxTropical {
    /// Class for max tropical algebra.
    /// x + y is max(x, y) and x * y is x + y
    x: f64,
}
impl MaxTropical {
    fn new(x: f64) -> Self {
        MaxTropical { x: x }
    }
    fn pow(self, other: MaxTropical) -> MaxTropical {
        MaxTropical {
            x: self.x * other.x,
        }
    }
}
impl Add<MaxTropical> for MaxTropical {
    type Output = MaxTropical;
    fn add(self, rhs: MaxTropical) -> MaxTropical {
        MaxTropical {
            x: if self.x > rhs.x { self.x } else { rhs.x },
        }
    }
}
impl Mul<MaxTropical> for MaxTropical {
    type Output = MaxTropical;
    fn mul(self, rhs: MaxTropical) -> MaxTropical {
        MaxTropical { x: self.x + rhs.x }
    }
}

fn main() {
    let a = MaxTropical::new(-2.);
    let b = MaxTropical::new(-1.);
    let c = MaxTropical::new(-0.5);
    let d = MaxTropical::new(-0.001);
    let e = MaxTropical::new(0.);
    let f = MaxTropical::new(1.5);
    let g = MaxTropical::new(2.);
    let h = MaxTropical::new(5.);
    let i = MaxTropical::new(7.);
    let j = MaxTropical::new(8.);
    let k = MaxTropical::new(-INFINITY);

    println!("2 * -2 == {:?}", g * a);
    println!("-0.001 + -Inf == {:?}", d + k);
    println!("0 * -Inf == {:?}", e * k);
    println!("1.5 + -1 == {:?}", f + b);
    println!("-0.5 * 0 == {:?}", c * e);
    println!("5.pow(7) == {:?}", h.pow(i));
    println!("5 * (8 + 7)) == {:?}", h * (j + i));
    println!("5 * 8 + 5 * 7 == {:?}", h * j + h * i);
    println!("5 * (8 + 7) == 5 * 8 + 5 * 7 is {}", h * (j + i) == h * j + h * i);
}
