extern crate num;
num::bigint::BigUint;

use std::time::Instant;

fn basic_hamming(n: usize) -> BigUint {
    let two = BigUint::from(2u8);
    let three = BigUint::from(3u8);
    let five = BigUint::from(5u8);
    let mut h = vec![BigUint::from(0u8); n];
    h[0] = BigUint::from(1u8);
    let mut x2 = BigUint::from(2u8);
    let mut x3 = BigUint::from(3u8);
    let mut x5 = BigUint::from(5u8);
    let mut i = 0usize; let mut j = 0usize; let mut k = 0usize;

    // BigUint comparisons are expensive, so do it only as necessary...
    fn min3(x: &BigUint, y: &BigUint, z: &BigUint) -> (usize, BigUint) {
        let (cs, r1) = if y == z { (0x6, y) }
                        else if y < z { (2, y) } else { (4, z) };
        if x == r1 { (cs | 1, x.clone()) }
        else if x < r1 { (1, x.clone()) } else { (cs, r1.clone()) }
    }

    let mut c = 1;
    while c < n { // satisfy borrow checker with extra blocks: {  }
        let (cs, e1) = { min3(&x2, &x3, &x5) };
        h[c] = e1; // vector now owns the generated value
        if (cs & 1) != 0 { i += 1; x2 = &two * &h[i] }
        if (cs & 2) != 0 { j += 1; x3 = &three * &h[j] }	
        if (cs & 4) != 0 { k += 1; x5 = &five * &h[k] }
        c += 1;
    }

    match h.pop() {
        Some(v) => v,
        _ => panic!("basic_hamming: arg is zero; no elements")
    }
}

fn main() {
    print!("[");
    for (i, h) in (1..21).map(basic_hamming).enumerate() {
        if i != 0 { print!(",") }
        print!(" {}", h)
    }
    println!(" ]");
    println!("{}", basic_hamming(1691));

    let strt = Instant::now();

    let rslt = basic_hamming(1000000);

    let elpsd = strt.elapsed();
    let secs = elpsd.as_secs();
    let millis = (elpsd.subsec_nanos() / 1000000)as u64;
    let dur = secs * 1000 + millis;

    let rs = rslt.to_str_radix(10);
    let mut s = rs.as_str();
    println!("{} digits:", s.len());
        while s.len() > 100 {
            let (f, r) = s.split_at(100);
            s = r;
            println!("{}", f);
        }
        println!("{}", s);

    println!("This last took {} milliseconds", dur);
}
