use num_bigint::{ToBigInt, BigInt};
use num_traits::{Zero, One};
//use std::mem::replace in the loop if you want this to be more efficient

fn main() {
    test(61u64);
    test(109u64);
    test(181u64);
    test(277u64);
}

struct Pair {
    v1: BigInt,
    v2: BigInt,
}

impl Pair {
    pub fn make_pair(a: &BigInt, b: &BigInt) -> Pair {
        Pair {
            v1: a.clone(),
            v2: b.clone(),
        }
    }

}

fn solve_pell(n: u64) -> Pair{
    let x: BigInt = ((n as f64).sqrt()).to_bigint().unwrap();
    if x.clone() * x.clone() == n.to_bigint().unwrap() {
        Pair::make_pair(&One::one(), &Zero::zero())
    } else {
        let mut y: BigInt = x.clone();
        let mut z: BigInt = One::one();
        let mut r: BigInt = ( &z + &z) * x.clone();
        let mut e: Pair = Pair::make_pair(&One::one(), &Zero::zero());
        let mut f: Pair = Pair::make_pair(&Zero::zero() ,&One::one());
        let mut a: BigInt = Zero::zero();
        let mut b: BigInt = Zero::zero();
        while &a * &a - n * &b * &b != One::one() {
            //println!("{}  {}  {}", y, z, r);
            y = &r * &z - &y;
            z = (n - &y * &y) / &z;
            r = (&x + &y) / &z;

            e = Pair::make_pair(&e.v2, &(&r * &e.v2 + &e.v1));
            f = Pair::make_pair(&f.v2, &(&r * &f.v2 + &f.v1));
            a = &e.v2 + &x * &f.v2;
            b = f.v2.clone();
        }
        let pa = &a;
        let pb = &b;
        Pair::make_pair(&pa.clone(), &pb.clone())
    }
}

fn test(n: u64) {
    let r: Pair = solve_pell(n);
    println!("x^2 - {} * y^2 = 1 for x = {} and y = {}", n, r.v1, r.v2);
}
