#[derive(Copy, Clone)]
struct Fraction {
    numerator: u32,
    denominator: u32,
}

use std::fmt;

impl fmt::Display for Fraction {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}/{}", self.numerator, self.denominator)
    }
}

impl Fraction {
    fn new(n: u32, d: u32) -> Fraction {
        Fraction {
            numerator: n,
            denominator: d,
        }
    }
}

fn farey_sequence(n: u32) -> impl std::iter::Iterator<Item = Fraction> {
    let mut a = 0;
    let mut b = 1;
    let mut c = 1;
    let mut d = n;
    std::iter::from_fn(move || {
        if a > n {
            return None;
        }
        let result = Fraction::new(a, b);
        let k = (n + b) / d;
        let next_c = k * c - a;
        let next_d = k * d - b;
        a = c;
        b = d;
        c = next_c;
        d = next_d;
        Some(result)
    })
}

fn main() {
    for n in 1..=11 {
        print!("{}:", n);
        for f in farey_sequence(n) {
            print!(" {}", f);
        }
        println!();
    }
    for n in (100..=1000).step_by(100) {
        println!("{}: {}", n, farey_sequence(n).count());
    }
}
