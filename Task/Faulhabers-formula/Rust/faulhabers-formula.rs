use num::integer::gcd;
use std::fmt;
use std::ops::{Add, Mul, Neg, Sub};

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
struct Frac {
    num: i64,
    denom: i64,
}

impl Frac {
    fn new(n: i64, d: i64) -> Self {
        if d == 0 {
            panic!("d must not be zero");
        }

        let mut nn = n;
        let mut dd = d;

        if nn == 0 {
            dd = 1;
        } else if dd < 0 {
            nn = -nn;
            dd = -dd;
        }

        let g = gcd(nn.abs(), dd.abs());
        if g > 1 {
            nn /= g;
            dd /= g;
        }

        Frac { num: nn, denom: dd }
    }

    fn zero() -> Self {
        Frac::new(0, 1)
    }

    fn one() -> Self {
        Frac::new(1, 1)
    }
}

impl Neg for Frac {
    type Output = Self;

    fn neg(self) -> Self {
        Frac::new(-self.num, self.denom)
    }
}

impl Add for Frac {
    type Output = Self;

    fn add(self, rhs: Self) -> Self {
        Frac::new(
            self.num * rhs.denom + self.denom * rhs.num,
            rhs.denom * self.denom,
        )
    }
}

impl Sub for Frac {
    type Output = Self;

    fn sub(self, rhs: Self) -> Self {
        Frac::new(
            self.num * rhs.denom - self.denom * rhs.num,
            rhs.denom * self.denom,
        )
    }
}

impl Mul for Frac {
    type Output = Self;

    fn mul(self, rhs: Self) -> Self {
        Frac::new(self.num * rhs.num, self.denom * rhs.denom)
    }
}

impl fmt::Display for Frac {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        if self.num == 0 || self.denom == 1 {
            write!(f, "{}", self.num)
        } else {
            write!(f, "{}/{}", self.num, self.denom)
        }
    }
}

fn bernoulli(n: i32) -> Frac {
    if n < 0 {
        panic!("n may not be negative or zero");
    }

    let mut a: Vec<Frac> = Vec::new();
    for m in 0..=n {
        a.push(Frac::new(1, (m + 1) as i64));
        for j in (1..=m).rev() {
            let j_usize = j as usize;
            a[j_usize - 1] = (a[j_usize - 1] - a[j_usize]) * Frac::new(j as i64, 1);
        }
    }

    // returns 'first' Bernoulli number
    if n != 1 {
        a[0]
    } else {
        -a[0]
    }
}

fn binomial(n: i32, k: i32) -> i64 {
    if n < 0 || k < 0 || n < k {
        panic!("parameters are invalid");
    }
    if n == 0 || k == 0 {
        return 1;
    }

    let mut num: i64 = 1;
    for i in (k + 1)..=n {
        num *= i as i64;
    }

    let mut denom: i64 = 1;
    for i in 2..=(n - k) {
        denom *= i as i64;
    }

    num / denom
}

fn faulhaber(p: i32) {
    print!("{} : ", p);

    let q = Frac::new(1, (p + 1) as i64);
    let mut sign: i32 = -1;
    for j in 0..=p {
        sign *= -1;
        let coeff = q * Frac::new(sign as i64, 1) * Frac::new(binomial(p + 1, j), 1) * bernoulli(j);
        if coeff == Frac::zero() {
            continue;
        }
        if j == 0 {
            if coeff == -Frac::one() {
                print!("-");
            } else if coeff != Frac::one() {
                print!("{}", coeff);
            }
        } else {
            if coeff == Frac::one() {
                print!(" + ");
            } else if coeff == -Frac::one() {
                print!(" - ");
            } else if coeff < Frac::zero() {
                print!(" - {}", -coeff);
            } else {
                print!(" + {}", coeff);
            }
        }
        let pwr = p + 1 - j;
        if pwr > 1 {
            print!("n^{}", pwr);
        } else {
            print!("n");
        }
    }
    println!();
}

fn main() {
    for i in 0..10 {
        faulhaber(i);
    }
}
