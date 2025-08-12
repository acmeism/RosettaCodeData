use std::fmt;
use std::ops::{Add, AddAssign, Sub, SubAssign, Mul, MulAssign, Neg};

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct EllipticPoint {
    x: f64,
    y: f64,
}

impl EllipticPoint {
    const ZERO_THRESHOLD: f64 = 1e20;
    const B: f64 = 7.0; // the 'b' in y^2 = x^3 + a * x + b, where 'a' is 0

    /// Create a point that is initialized to Zero (point at infinity)
    pub fn new() -> Self {
        Self {
            x: 0.0,
            y: Self::ZERO_THRESHOLD * 1.01,
        }
    }

    /// Create a point based on the y-coordinate. For a curve with a = 0 and b = 7
    /// there is only one x for each y
    pub fn from_y(y_coordinate: f64) -> Self {
        let y = y_coordinate;
        let x = (y * y - Self::B).cbrt();
        Self { x, y }
    }

    /// Check if the point is zero (point at infinity)
    pub fn is_zero(&self) -> bool {
        // when the elliptic point is at zero, y = +/- infinity
        self.y.abs() >= Self::ZERO_THRESHOLD
    }

    /// Double the point (multiply by 2)
    fn double(&mut self) {
        if self.is_zero() {
            // doubling zero is still zero
            return;
        }

        // based on the property of the curve, the line going through the
        // current point and the negative doubled point is tangent to the
        // curve at the current point. wikipedia has a nice diagram.
        if self.y == 0.0 {
            // at this point the tangent to the curve is vertical.
            // this point doubled is 0
            *self = EllipticPoint::new();
        } else {
            let l = (3.0 * self.x * self.x) / (2.0 * self.y);
            let new_x = l * l - 2.0 * self.x;
            self.y = l * (self.x - new_x) - self.y;
            self.x = new_x;
        }
    }
}

impl Default for EllipticPoint {
    fn default() -> Self {
        Self::new()
    }
}

impl fmt::Display for EllipticPoint {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        if self.is_zero() {
            write!(f, "(Zero)")
        } else {
            write!(f, "({}, {})", self.x, self.y)
        }
    }
}

impl Neg for EllipticPoint {
    type Output = Self;

    fn neg(self) -> Self::Output {
        Self {
            x: self.x,
            y: -self.y,
        }
    }
}

impl Add for EllipticPoint {
    type Output = Self;

    fn add(self, rhs: Self) -> Self::Output {
        let mut result = self;
        result += rhs;
        result
    }
}

impl AddAssign for EllipticPoint {
    fn add_assign(&mut self, rhs: Self) {
        if self.is_zero() {
            *self = rhs;
        } else if rhs.is_zero() {
            // since rhs is zero this point does not need to be modified
        } else {
            let l = (rhs.y - self.y) / (rhs.x - self.x);
            if l.is_finite() {
                let new_x = l * l - self.x - rhs.x;
                self.y = l * (self.x - new_x) - self.y;
                self.x = new_x;
            } else {
                if self.y.is_sign_negative() != rhs.y.is_sign_negative() {
                    // in this case rhs == -lhs, the result should be 0
                    *self = EllipticPoint::new();
                } else {
                    // in this case rhs == lhs.
                    self.double();
                }
            }
        }
    }
}

impl Sub for EllipticPoint {
    type Output = Self;

    fn sub(self, rhs: Self) -> Self::Output {
        self + (-rhs)
    }
}

impl SubAssign for EllipticPoint {
    fn sub_assign(&mut self, rhs: Self) {
        *self += -rhs;
    }
}

impl Mul<i32> for EllipticPoint {
    type Output = Self;

    fn mul(self, rhs: i32) -> Self::Output {
        let mut result = self;
        result *= rhs;
        result
    }
}

impl Mul<EllipticPoint> for i32 {
    type Output = EllipticPoint;

    fn mul(self, rhs: EllipticPoint) -> Self::Output {
        rhs * self
    }
}

impl MulAssign<i32> for EllipticPoint {
    fn mul_assign(&mut self, mut rhs: i32) {
        let mut r = EllipticPoint::new();
        let mut p = *self;

        if rhs < 0 {
            // change p * -rhs to -p * rhs
            rhs = -rhs;
            p = -p;
        }

        let mut i = 1;
        while i <= rhs {
            if (i & rhs) != 0 {
                r += p;
            }
            p.double();
            i <<= 1;
        }

        *self = r;
    }
}

fn main() {
    let a = EllipticPoint::from_y(1.0);
    let b = EllipticPoint::from_y(2.0);

    println!("a = {}", a);
    println!("b = {}", b);

    let c = a + b;
    println!("c = a + b = {}", c);
    println!("a + b - c = {}", a + b - c);
    println!("a + b - (b + a) = {}\n", a + b - (b + a));

    println!("a + a + a + a + a - 5 * a = {}", a + a + a + a + a - 5 * a);
    println!("a * 12345 = {}", a * 12345);
    println!("a * -12345 = {}", a * -12345);
    println!("a * 12345 + a * -12345 = {}", a * 12345 + a * -12345);
    println!("a * 12345 - (a * 12000 + a * 345) = {}", a * 12345 - (a * 12000 + a * 345));
    println!("a * 12345 - (a * 12001 + a * 345) = {}\n", a * 12345 - (a * 12000 + a * 344));

    let zero = EllipticPoint::new();
    let mut g = EllipticPoint::new();
    println!("g = zero = {}", g);
    g += a;
    println!("g += a = {}", g);
    g += zero;
    println!("g += zero = {}", g);
    g += b;
    println!("g += b = {}", g);
    println!("b + b - b * 2 = {}\n", b + b - b * 2);

    let mut special = EllipticPoint::from_y(0.0); // the point where the curve crosses the x-axis
    println!("special = {}", special); // this has the minimum possible value for x
    special *= 2;
    println!("special *= 2 = {}", special); // doubling it gives zero
}
