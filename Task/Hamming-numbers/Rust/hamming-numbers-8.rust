extern crate num; // requires dependency on the num library
use num::bigint::BigUint;

use std::time::Instant;

fn nth_hamming(n: u64) -> (u32, u32, u32) {
    if n < 2 {
        if n <= 0 { panic!("nth_hamming: argument is zero; no elements") }
        return (0, 0, 0) // trivial case for n == 1
    }

    let lg3 = 3.0f64.ln() / 2.0f64.ln(); // log base 2 of 3
    let lg5 = 5.0f64.ln() / 2.0f64.ln(); // log base 2 of 5
    let fctr = 6.0f64 * lg3 * lg5;
    let crctn = 30.0f64.sqrt().ln() / 2.0f64.ln(); // log base 2 of sqrt 30
    let lgest = (fctr * n as f64).powf(1.0f64/3.0f64)
                    - crctn; // from WP formula
    let frctn = if n < 1000000000 { 0.509f64 } else { 0.105f64 };
    let lghi = (fctr * (n as f64 + frctn * lgest)).powf(1.0f64/3.0f64)
                    - crctn; // calculate hi log limit based on log(N) - WP article
    let lglo = 2.0f64 * lgest - lghi; // and a lower limit of the upper "band"
    let mut count = 0; // need to use extended precision, might go over
    let mut bnd = Vec::with_capacity(0);
    let klmt = (lghi / lg5) as u32 + 1;
    for k in 0 .. klmt { // i, j, k values can be just u32 values
        let p = k as f64 * lg5;
        let jlmt = ((lghi - p) / lg3) as u32 + 1;
        for j in 0 .. jlmt {
            let q = p + j as f64 * lg3;
            let ir = lghi - q;
            let lg = q + (ir as u32) as f64; // current log value (estimated)
            count += ir as u64 + 1;
            if lg >= lglo {
                bnd.push((lg, (ir as u32, j, k)))
            }
        }
    }
    if n > count { panic!("nth_hamming: band high estimate is too low!") };
    let ndx = (count - n) as usize;
    if ndx >= bnd.len() { panic!("nth_hamming: band low estimate is too high!") };
    bnd.sort_by(|a, b| b.0.partial_cmp(&a.0).unwrap()); // sort decreasing order

    bnd[ndx].1
}

fn convert_log2big(o: (u32, u32, u32)) -> BigUint {
    let two = BigUint::from(2u8);
    let three = BigUint::from(3u8);
    let five = BigUint::from(5u8);
    let (x2, x3, x5) = o;
    let mut ob = BigUint::from(1u8); // convert to BigUint at the end
    for _ in 0 .. x2 { ob = ob * &two }
    for _ in 0 .. x3 { ob = ob * &three }
    for _ in 0 .. x5 { ob = ob * &five }
    ob
}

fn main() {
    print!("[");
    for (i, h) in (1 .. 21).map(nth_hamming).enumerate() {
        if i != 0 { print!(",") }
        print!(" {}", convert_log2big(h))
    }
    println!(" ]");
    println!("{}", convert_log2big(nth_hamming(1691)));

    let strt = Instant::now();

    let rslt = nth_hamming(1000000);

    let elpsd = strt.elapsed();
    let secs = elpsd.as_secs();
    let millis = (elpsd.subsec_nanos() / 1000000)as u64;
    let dur = secs * 1000 + millis;

    println!("2^{} times 3^{} times 5^{}", rslt.0, rslt.1, rslt.2);
    let rs = convert_log2big(rslt).to_str_radix(10);
    let mut s = rs.as_str();
    println!("{} digits:", s.len());
    let lg3 = 3.0f64.log2();
    let lg5 = 5.0f64.log2();
    let lg = (rslt.0 as f64 + rslt.1 as f64 * lg3
            + rslt.2 as f64 * lg5) * 2.0f64.log10();
    println!("Approximately {}E+{}", 10.0f64.powf(lg.fract()), lg.trunc());
    if s.len() <= 10000 {
        while s.len() > 100 {
            let (f, r) = s.split_at(100);
            s = r;
            println!("{}", f);
        }
        println!("{}", s);
    }

    println!("This last took {} milliseconds.", dur);
}
