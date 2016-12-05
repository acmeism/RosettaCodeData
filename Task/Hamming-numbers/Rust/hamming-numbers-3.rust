fn log_nodups_hamming(n: u64) -> BigUint {
    if n <= 0 { panic!("nodups_hamming: arg is zero; no elements") }
    if n < 2 { return BigUint::from(1u8) } // trivial case for n == 1
    if n > 1.2e13 as u64 { panic!("log_nodups_hamming: argument too large to guarantee results!") }

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

    let mut h = Vec::with_capacity(65536); // vec!(one.clone(); 0);
    let mut m = Vec::<Logelm>::with_capacity(65536); // vec!(one.clone(); 0);

    let mut i = 0usize; let mut j = 0usize;
    for _ in 1 .. n {
        let cph = h.capacity();
        if i > cph / 2 { // drain extra unneeded values...
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
            if j > cpm / 2 { // drain extra unneeded values...
                m.drain(0 .. j);
                j = 0;
            }
            m.push(mrg);
        }
    }

    let o = &h[&h.len() - 1];
    let two = BigUint::from(2u8);
    let three = BigUint::from(3u8);
    let five = BigUint::from(5u8);
    let mut ob = BigUint::from(1u8); // convert to BigUint at the end
    for _ in 0 .. o.exp2 { ob = ob * &two }
    for _ in 0 .. o.exp3 { ob = ob * &three }
    for _ in 0 .. o.exp5 { ob = ob * &five }
    ob
}
