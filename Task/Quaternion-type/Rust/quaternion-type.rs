use std::fmt::{Display, Error, Formatter};
use std::ops::{Add, Mul, Neg};

#[derive(Clone,Copy,Debug)]
struct Quaternion {
    a: f64,
    b: f64,
    c: f64,
    d: f64
}

impl Quaternion {
    pub fn new(a: f64, b: f64, c: f64, d: f64) -> Quaternion {
        Quaternion {
            a: a,
            b: b,
            c: c,
            d: d
        }
    }

    pub fn norm(&self) -> f64 {
        (self.a.powi(2) + self.b.powi(2) + self.c.powi(2) + self.d.powi(2)).sqrt()
    }

    pub fn conjugate(&self) -> Quaternion {
        Quaternion {
            a: self.a,
            b: -self.b,
            c: -self.c,
            d: -self.d
        }
    }
}

impl Add for Quaternion {
    type Output = Quaternion;

    #[inline]
    fn add(self, other: Quaternion) -> Self::Output {
        Quaternion {
            a: self.a + other.a,
            b: self.b + other.b,
            c: self.c + other.c,
            d: self.d + other.d
        }
    }
}

impl Add<f64> for Quaternion {
    type Output = Quaternion;

    #[inline]
    fn add(self, other: f64) -> Self::Output {
        Quaternion {
            a: self.a + other,
            b: self.b,
            c: self.c,
            d: self.d
        }
    }
}

impl Add<Quaternion> for f64 {
    type Output = Quaternion;

    #[inline]
    fn add(self, other: Quaternion) -> Self::Output {
        Quaternion {
            a: other.a + self,
            b: other.b,
            c: other.c,
            d: other.d
        }
    }
}

impl Display for Quaternion {
    fn fmt(&self, f: &mut Formatter) -> Result<(), Error> {
        write!(f, "({} + {}i + {}j + {}k)", self.a, self.b, self.c, self.d)
    }
}

impl Mul for Quaternion {
    type Output = Quaternion;

    #[inline]
    fn mul(self, rhs: Quaternion) -> Self::Output {
        Quaternion {
            a: self.a * rhs.a - self.b * rhs.b - self.c * rhs.c - self.d * rhs.d,
            b: self.a * rhs.b + self.b * rhs.a + self.c * rhs.d - self.d * rhs.c,
            c: self.a * rhs.c - self.b * rhs.d + self.c * rhs.a + self.d * rhs.b,
            d: self.a * rhs.d + self.b * rhs.c - self.c * rhs.b + self.d * rhs.a,
        }
    }
}

impl Mul<f64> for Quaternion {
    type Output = Quaternion;

    #[inline]
    fn mul(self, other: f64) -> Self::Output {
        Quaternion {
            a: self.a * other,
            b: self.b * other,
            c: self.c * other,
            d: self.d * other
        }
    }
}

impl Mul<Quaternion> for f64 {
    type Output = Quaternion;

    #[inline]
    fn mul(self, other: Quaternion) -> Self::Output {
        Quaternion {
            a: other.a * self,
            b: other.b * self,
            c: other.c * self,
            d: other.d * self
        }
    }
}

impl Neg for Quaternion {
    type Output = Quaternion;

    #[inline]
    fn neg(self) -> Self::Output {
        Quaternion {
            a: -self.a,
            b: -self.b,
            c: -self.c,
            d: -self.d
        }
    }
}

fn main() {
    let q0 = Quaternion { a: 1., b: 2., c: 3., d: 4. };
    let q1 = Quaternion::new(2., 3., 4., 5.);
    let q2 = Quaternion::new(3., 4., 5., 6.);
    let r: f64 = 7.;

    println!("q0 = {}", q0);
    println!("q1 = {}", q1);
    println!("q2 = {}", q2);
    println!("r  = {}", r);
    println!();
    println!("-q0 = {}", -q0);
    println!("conjugate of q0 = {}", q0.conjugate());
    println!();
    println!("r + q0 = {}", r + q0);
    println!("q0 + r = {}", q0 + r);
    println!();
    println!("r * q0 = {}", r * q0);
    println!("q0 * r = {}", q0 * r);
    println!();
    println!("q0 + q1 = {}", q0 + q1);
    println!("q0 * q1 = {}", q0 * q1);
    println!();
    println!("q0 * (conjugate of q0) = {}", q0 * q0.conjugate());
    println!();
    println!(" q0 + q1  * q2 = {}", q0 + q1 * q2);
    println!("(q0 + q1) * q2 = {}", (q0 + q1) * q2);
    println!();
    println!(" q0 *  q1  * q2  = {}", q0 *q1 * q2);
    println!("(q0 *  q1) * q2  = {}", (q0 * q1) * q2);
    println!(" q0 * (q1  * q2) = {}", q0 * (q1 * q2));
    println!();
    println!("normal of q0 = {}", q0.norm());
}
