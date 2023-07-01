#[cfg(target_pointer_width = "64")]
type USingle = u32;
#[cfg(target_pointer_width = "64")]
type UDouble = u64;
#[cfg(target_pointer_width = "64")]
const WORD_LEN: i32 = 32;

#[cfg(not(target_pointer_width = "64"))]
type USingle = u16;
#[cfg(not(target_pointer_width = "64"))]
type UDouble = u32;
#[cfg(not(target_pointer_width = "64"))]
const WORD_LEN: i32 = 16;

use std::cmp;

#[derive(Debug,Clone)]
struct BigNum {
    // rep_.size() == 0 if and only if the value is zero.
    // Otherwise, the word rep_[0] keeps the least significant bits.
    rep_: Vec<USingle>,
}

impl BigNum {
    pub fn new(n: USingle) -> BigNum {
        let mut result = BigNum { rep_: vec![] };
        if n > 0 { result.rep_.push(n); }
        result
    }
    pub fn equals(&self, n: USingle) -> bool {
        if n == 0 { return self.rep_.is_empty() }
        if self.rep_.len() > 1 { return false }
        self.rep_[0] == n
    }
    pub fn add_big(&self, addend: &BigNum) -> BigNum {
        let mut result = BigNum::new(0);
        let mut sum = 0 as UDouble;
        let sz1 = self.rep_.len();
        let sz2 = addend.rep_.len();
        for i in 0..cmp::max(sz1, sz2) {
            if i < sz1 { sum += self.rep_[i] as UDouble }
            if i < sz2 { sum += addend.rep_[i] as UDouble }
            result.rep_.push(sum as USingle);
            sum >>= WORD_LEN;
        }
        if sum > 0 { result.rep_.push(sum as USingle) }
        result
    }
    pub fn multiply(&self, factor: USingle) -> BigNum {
        let mut result = BigNum::new(0);
        let mut product = 0 as UDouble;
        for i in 0..self.rep_.len() {
            product += self.rep_[i] as UDouble * factor as UDouble;
            result.rep_.push(product as USingle);
            product >>= WORD_LEN;
        }
        if product > 0 {
            result.rep_.push(product as USingle);
        }
        result
    }
    pub fn divide(&self, divisor: USingle, quotient: &mut BigNum,
        remainder: &mut USingle) {
        quotient.rep_.truncate(0);
        let mut dividend: UDouble;
        *remainder = 0;
        for i in 0..self.rep_.len() {
            let j = self.rep_.len() - 1 - i;
            dividend = ((*remainder as UDouble) << WORD_LEN)
                + self.rep_[j] as UDouble;
            let quo = (dividend / divisor as UDouble) as USingle;
            *remainder = (dividend % divisor as UDouble) as USingle;
            if quo > 0 || j < self.rep_.len() - 1 {
                quotient.rep_.push(quo);
            }
        }
        quotient.rep_.reverse();
    }
    fn to_string(&self) -> String {
        let mut rep = String::new();
        let mut dividend = (*self).clone();
        let mut remainder = 0 as USingle;
        let mut quotient = BigNum::new(0);
        loop {
            dividend.divide(10, &mut quotient, &mut remainder);
            rep.push(('0' as USingle + remainder) as u8 as char);
            if quotient.equals(0) { break; }
            dividend = quotient.clone();
        }
        rep.chars().rev().collect::<String>()
    }
}

use std::fmt;
impl fmt::Display for BigNum {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.to_string())
    }
}

fn lfact(n: USingle) -> BigNum {
    let mut result = BigNum::new(0);
    let mut f = BigNum::new(1);
    for k in 1 as USingle..n + 1 {
        result = result.add_big(&f);
        f = f.multiply(k);
    }
    result
}

fn main() {
    for i in 0..11 {
        println!("!{} = {}", i, lfact(i));
    }
    for i in 2..12 {
        let j = i * 10;
        println!("!{} = {}", j, lfact(j));
    }
    for i in 1..11 {
        let j = i * 1000;
        println!("!{} has {} digits.", j, lfact(j).to_string().len());
    }
}
