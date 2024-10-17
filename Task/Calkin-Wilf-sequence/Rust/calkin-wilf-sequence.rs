// [dependencies]
// num = "0.3"

use num::rational::Rational;

fn calkin_wilf_next(term: &Rational) -> Rational {
    Rational::from_integer(1) / (Rational::from_integer(2) * term.floor() + 1 - term)
}

fn continued_fraction(r: &Rational) -> Vec<isize> {
    let mut a = *r.numer();
    let mut b = *r.denom();
    let mut result = Vec::new();
    loop {
        let (q, r) = num::integer::div_rem(a, b);
        result.push(q);
        a = b;
        b = r;
        if a == 1 {
            break;
        }
    }
    let len = result.len();
    if len != 0 && len % 2 == 0 {
        result[len - 1] -= 1;
        result.push(1);
    }
    result
}

fn term_number(r: &Rational) -> usize {
    let mut result: usize = 0;
    let mut d: usize = 1;
    let mut p: usize = 0;
    for n in continued_fraction(r) {
        for _ in 0..n {
            result |= d << p;
            p += 1;
        }
        d ^= 1;
    }
    result
}

fn main() {
    println!("First 20 terms of the Calkin-Wilf sequence are:");
    let mut term = Rational::from_integer(1);
    for i in 1..=20 {
        println!("{:2}: {}", i, term);
        term = calkin_wilf_next(&term);
    }
    let r = Rational::new(83116, 51639);
    println!("{} is the {}th term of the sequence.", r, term_number(&r));
}
