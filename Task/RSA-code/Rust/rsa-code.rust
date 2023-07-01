extern crate num;

use num::bigint::BigUint;
use num::integer::Integer;
use num::traits::{One, Zero};

fn mod_exp(b: &BigUint, e: &BigUint, n: &BigUint) -> Result<BigUint, &'static str> {
    if n.is_zero() {
        return Err("modulus is zero");
    }
    if b >= n {
        // base is too large and should be split into blocks
        return Err("base is >= modulus");
    }
    if b.gcd(n) != BigUint::one() {
        return Err("base and modulus are not relatively prime");
    }

    let mut bb = b.clone();
    let mut ee = e.clone();
    let mut result = BigUint::one();
    while !ee.is_zero() {
        if ee.is_odd() {
            result = (result * &bb) % n;
        }
        ee >>= 1;
        bb = (&bb * &bb) % n;
    }
    Ok(result)
}

fn main() {
    let msg = "Rosetta Code";

    let n = "9516311845790656153499716760847001433441357"
        .parse()
        .unwrap();
    let e = "65537".parse().unwrap();
    let d = "5617843187844953170308463622230283376298685"
        .parse()
        .unwrap();

    let msg_int = BigUint::from_bytes_be(msg.as_bytes());
    let enc = mod_exp(&msg_int, &e, &n).unwrap();
    let dec = mod_exp(&enc, &d, &n).unwrap();
    let msg_dec = String::from_utf8(dec.to_bytes_be()).unwrap();

    println!("msg as txt: {}", msg);
    println!("msg as num: {}", msg_int);
    println!("enc as num: {}", enc);
    println!("dec as num: {}", dec);
    println!("dec as txt: {}", msg_dec);
}
