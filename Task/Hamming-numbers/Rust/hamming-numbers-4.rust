extern crate num; // requires dependency on the num library
use num::bigint::BigUint;

use std::time::Instant;

fn log_nodups_hamming_iter() -> Box<Iterator<Item = (u16, u16, u16)>> {
    // constants as expanded integers to minimize round-off errors, and
    // reduce execution time using integer operations not float...
    const LAA2: u64 = 35184372088832; // 2.0f64.powi(45)).round() as u64;
    const LBA2: u64 = 55765910372219; // 3.0f64.log2() * 2.0f64.powi(45)).round() as u64;
    const LCA2: u64 = 81695582054030; // 5.0f64.log2() * 2.0f64.powi(45)).round() as u64;

    #[derive(Clone, Copy)]
    struct Logelm { // log representation of an element with only allowable powers
        exp2: u16,
        exp3: u16,
        exp5: u16,
        logr: u64 // log representation used for comparison only - not exact
    }
    impl Logelm {
        fn lte(&self, othr: &Logelm) -> bool {
            if self.logr <= othr.logr { true } else { false }
        }
        fn mul2(&self) -> Logelm {
            Logelm { exp2: self.exp2 + 1, logr: self.logr + LAA2, .. *self }
        }
        fn mul3(&self) -> Logelm {
            Logelm { exp3: self.exp3 + 1, logr: self.logr + LBA2, .. *self }
        }
        fn mul5(&self) -> Logelm {
            Logelm { exp5: self.exp5 + 1, logr: self.logr + LCA2, .. *self }
        }
    }

    let one = Logelm { exp2: 0, exp3: 0, exp5: 0, logr: 0 };
    let mut x532 = one.mul2();
    let mut mrg = one.mul3();
    let mut x53 = one.mul3().mul3(); // advance as mrg has the former value...
    let mut x5 = one.mul5();

    let mut h = Vec::with_capacity(65536);
    let mut m = Vec::<Logelm>::with_capacity(65536);

    let mut i = 0usize; let mut j = 0usize;
    Box::new((0u64 .. ).map(move |it| if it < 1 { (0, 0, 0) } else {
        let cph = h.capacity();
        if i > cph / 2 {
            h.drain(0 .. i);
            i = 0;
        }
        if x532.lte(&mrg) {
            h.push(x532);
            x532 = h[i].mul2();
            i += 1;
        } else {
            h.push(mrg);
            if x53.lte(&x5) {
                mrg = x53;
                x53 = m[j].mul3();
                j += 1;
            } else {
                mrg = x5;
                x5 = x5.mul5();
            }
            let cpm = m.capacity();
            if j > cpm / 2 {
                m.drain(0 .. j);
                j = 0;
            }
            m.push(mrg);
        }
        let o = &h[&h.len() - 1];
        (o.exp2, o.exp3, o.exp5)
    }))
}

fn convert_log2big(o: (u16, u16, u16)) -> BigUint {
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
    for (i, h) in log_nodups_hamming_iter().take(20).map(convert_log2big).enumerate() {
        if i != 0 { print!(",") }
        print!(" {}", h)
    }
    println!(" ]");
    println!("{}", convert_log2big(log_nodups_hamming_iter().take(1691).last().unwrap()));

    let strt = Instant::now();
	
//  let rslt = convert_log2big(log_nodups_hamming_iter().take(1000000000).last().unwrap());
    let mut it = log_nodups_hamming_iter().into_iter();
    for _ in 0 .. 100-1 { // a little faster; less one level of iteration
        let _ = it.next();
    }
    let rslt = convert_log2big(it.next().unwrap());

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
