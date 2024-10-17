use std::fmt;
use std::ops::{Add, Div, Mul, Sub};

#[derive(Copy, Clone, Debug)]
pub struct Vector<T> {
    pub x: T,
    pub y: T,
}

impl<T> fmt::Display for Vector<T>
where
    T: fmt::Display,
{
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        if let Some(prec) = f.precision() {
            write!(f, "[{:.*}, {:.*}]", prec, self.x, prec, self.y)
        } else {
            write!(f, "[{}, {}]", self.x, self.y)
        }
    }
}

impl<T> Vector<T> {
    pub fn new(x: T, y: T) -> Self {
        Vector { x, y }
    }
}

impl Vector<f64> {
    pub fn from_polar(r: f64, theta: f64) -> Self {
        Vector {
            x: r * theta.cos(),
            y: r * theta.sin(),
        }
    }
}

impl<T> Add for Vector<T>
where
    T: Add<Output = T>,
{
    type Output = Self;

    fn add(self, other: Self) -> Self::Output {
        Vector {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

impl<T> Sub for Vector<T>
where
    T: Sub<Output = T>,
{
    type Output = Self;

    fn sub(self, other: Self) -> Self::Output {
        Vector {
            x: self.x - other.x,
            y: self.y - other.y,
        }
    }
}

impl<T> Mul<T> for Vector<T>
where
    T: Mul<Output = T> + Copy,
{
    type Output = Self;

    fn mul(self, scalar: T) -> Self::Output {
        Vector {
            x: self.x * scalar,
            y: self.y * scalar,
        }
    }
}

impl<T> Div<T> for Vector<T>
where
    T: Div<Output = T> + Copy,
{
    type Output = Self;

    fn div(self, scalar: T) -> Self::Output {
        Vector {
            x: self.x / scalar,
            y: self.y / scalar,
        }
    }
}

fn main() {
    use std::f64::consts::FRAC_PI_3;

    println!("{:?}", Vector::new(4, 5));
    println!("{:.4}", Vector::from_polar(3.0, FRAC_PI_3));
    println!("{}", Vector::new(2, 3) + Vector::new(4, 6));
    println!("{:.4}", Vector::new(5.6, 1.3) - Vector::new(4.2, 6.1));
    println!("{:.4}", Vector::new(3.0, 4.2) * 2.3);
    println!("{:.4}", Vector::new(3.0, 4.2) / 2.3);
    println!("{}", Vector::new(3, 4) / 2);
}
