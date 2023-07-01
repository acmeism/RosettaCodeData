extern crate num;
use num::bigint::BigInt;

use core::fmt::Display;
use std::time::Instant;
use std::iter;

const NUM_ELEMENTS: usize = 1000000;

const LB2_2: f64 = 1.0_f64; // log2(2.0)
const LB2_3: f64 = 1.5849625007211563_f64; // log2(3.0)
const LB2_5: f64 = 2.321928094887362_f64; // log2(5.0)

#[derive (Clone)]
struct LogRep {
    lr: f64,
    x2: u32,
    x3: u32,
    x5: u32,
}
impl LogRep {
    fn int_value(&self) -> BigInt {
        BigInt::from(2).pow(self.x2) * BigInt::from(3).pow(self.x3) * BigInt::from(5).pow(self.x5)
    }

    #[inline(always)]
    fn mul2(&self) -> Self {
        LogRep {
            lr: self.lr + LB2_2,
            x2: self.x2 + 1,
            x3: self.x3,
            x5: self.x5,
        }
    }

    #[inline(always)]
    fn mul3(&self) -> Self {
        LogRep {
            lr: self.lr + LB2_3,
            x2: self.x2,
            x3: self.x3 + 1,
            x5: self.x5,
        }
    }

    #[inline(always)]
    fn mul5(&self) -> Self {
        LogRep {
            lr: self.lr + LB2_5,
            x2: self.x2,
            x3: self.x3,
            x5: self.x5 + 1,
        }
    }

}

impl Display for LogRep {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let val = self.int_value();
        let x2 = self.x2;
        let x3 = self.x3;
        let x5 = self.x5;
        write!(f, "[{x2} {x3} {x5}]=>{val}")
    }
}

const ONE: LogRep = LogRep { lr: 0.0, x2: 0, x3: 0, x5: 0 };
struct LogRepImperativeIterator {
    s2: Vec<LogRep>,
    s3: Vec<LogRep>,
    s5: LogRep,
    mrg: LogRep,
    s2i: usize,
    s3i: usize,
}
impl LogRepImperativeIterator {
    pub fn new() -> Self {
        LogRepImperativeIterator {
            s2: vec![ONE.mul2()],
            s3: vec![ONE.mul3()],
            s5: ONE.mul5(),
            mrg: ONE.mul3(),
            s2i: 0,
            s3i: 0,
        }
    }

    fn iter(&self) -> impl Iterator<Item = LogRep> {
        iter::once(ONE).chain(LogRepImperativeIterator::new())
    }
}
impl Iterator for LogRepImperativeIterator {
    type Item = LogRep;

    #[inline(always)]
    fn next(&mut self) -> Option<Self::Item> {
        if self.s2i + self.s2i >= self.s2.len() {
            self.s2.drain(0..self.s2i);
            self.s2i = 0;
        }
        let result: LogRep;
        if self.s2[self.s2i].lr < self.mrg.lr {
            self.s2.push(self.s2[self.s2i].mul2());
            result = self.s2[self.s2i].clone(); self.s2i += 1;
        } else {
            if self.s3i + self.s3i >= self.s3.len() {
                self.s3.drain(0..self.s3i);
                self.s3i = 0;
            }

            result = self.mrg.clone();
            self.s2.push(self.mrg.mul2());
            self.s3.push(self.mrg.mul3());

            self.s3i += 1;
            if self.s3[self.s3i].lr < self.s5.lr {
                self.mrg = self.s3[self.s3i].clone();
            } else {
                self.mrg = self.s5.clone();
                self.s5 = self.s5.mul5();
                self.s3i -= 1;
            }
        };

        Some(result)
    }
}

fn main() {
    LogRepImperativeIterator::new().iter().take(20)
        .for_each(&|h: LogRep| print!("{} ", h.int_value()));
    println!();

    println!("{} ", LogRepImperativeIterator::new().iter()
                        .take(1691).last().unwrap().int_value());

    let t0 = Instant::now();
    let rslt = LogRepImperativeIterator::new().iter()
                   .take(NUM_ELEMENTS).last().unwrap();
    let elpsd = t0.elapsed().as_micros() as f64;

    println!("{}", rslt.int_value());
    println!("This took {} microseconds for {} elements!", elpsd, NUM_ELEMENTS)
}
