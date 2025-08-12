use std::fmt;
use std::ops::{Add, Mul, Neg, Sub};

fn gcd(mut a: i32, mut b: i32) -> i32 {
    a = a.abs();
    b = b.abs();
    while b != 0 {
        let temp = b;
        b = a % b;
        a = temp;
    }
    a
}

#[derive(Debug, Clone, Copy)]
struct Frac {
    num: i32,
    denom: i32,
}

impl Frac {
    fn new(n: i32, d: i32) -> Result<Self, &'static str> {
        if d == 0 {
            return Err("Denominator must not be zero");
        }

        let sign_of_d = if d < 0 { -1 } else { 1 };
        let g = gcd(n, d);

        Ok(Frac {
            num: sign_of_d * n / g,
            denom: sign_of_d * d / g,
        })
    }

    fn zero() -> Self {
        Frac { num: 0, denom: 1 }
    }
}

impl Neg for Frac {
    type Output = Self;

    fn neg(self) -> Self::Output {
        Frac {
            num: -self.num,
            denom: self.denom,
        }
    }
}

impl Add for Frac {
    type Output = Self;

    fn add(self, rhs: Self) -> Self::Output {
        Frac::new(
            self.num * rhs.denom + self.denom * rhs.num,
            rhs.denom * self.denom,
        )
        .unwrap()
    }
}

impl Sub for Frac {
    type Output = Self;

    fn sub(self, rhs: Self) -> Self::Output {
        Frac::new(
            self.num * rhs.denom - self.denom * rhs.num,
            rhs.denom * self.denom,
        )
        .unwrap()
    }
}

impl Mul for Frac {
    type Output = Self;

    fn mul(self, rhs: Self) -> Self::Output {
        Frac::new(self.num * rhs.num, self.denom * rhs.denom).unwrap()
    }
}

impl Mul<i32> for Frac {
    type Output = Self;

    fn mul(self, rhs: i32) -> Self::Output {
        Frac::new(self.num * rhs, self.denom).unwrap()
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

fn bernoulli(n: i32) -> Result<Frac, &'static str> {
    if n < 0 {
        return Err("n may not be negative");
    }

    let mut a = Vec::new();
    for m in 0..=n {
        a.push(Frac::new(1, m + 1)?);
        for j in (1..=m).rev() {
            let j_idx = j as usize;
            a[j_idx - 1] = (a[j_idx - 1] - a[j_idx]) * j;
        }
    }

    // returns 'first' Bernoulli number
    if n != 1 {
        Ok(a[0])
    } else {
        Ok(-a[0])
    }
}

fn binomial(n: i32, k: i32) -> Result<i32, &'static str> {
    if n < 0 || k < 0 || n < k {
        return Err("Parameters are invalid");
    }
    if n == 0 || k == 0 {
        return Ok(1);
    }

    let mut num = 1;
    for i in (k + 1)..=n {
        num *= i;
    }

    let mut denom = 1;
    for i in 2..=(n - k) {
        denom *= i;
    }

    Ok(num / denom)
}

fn faulhaber_triangle(p: i32) -> Result<Vec<Frac>, &'static str> {
    let mut coeffs = vec![Frac::zero(); (p + 1) as usize];

    let q = Frac::new(1, p + 1)?;
    let mut sign = -1;

    for j in 0..=p {
        sign *= -1;
        let binom = binomial(p + 1, j)?;
        let bern = bernoulli(j)?;
        coeffs[(p - j) as usize] = q * sign * binom * bern;
    }

    Ok(coeffs)
}

fn main() -> Result<(), &'static str> {
    for i in 0..10 {
        let coeffs = faulhaber_triangle(i)?;
        for frac in coeffs {
            print!("{:>5}  ", frac);
        }
        println!();
    }

    Ok(())
}
