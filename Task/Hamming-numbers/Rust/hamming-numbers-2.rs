fn nodups_hamming(n: usize) -> BigUint {
    let two = BigUint::from(2u8);
    let three = BigUint::from(3u8);
    let five = BigUint::from(5u8);
    let mut m = vec![BigUint::from(0u8); 1];
    m[0] = BigUint::from(1u8);
    let mut h = vec![BigUint::from(0u8); n];
    h[0] = BigUint::from(1u8);
    if n > 1 {
        m.push(BigUint::from(3u8)); // for initial x53 advance
        h[1] = BigUint::from(2u8); // for initial x532 advance
    }
    let mut x5 = BigUint::from(5u8);
    let mut x53 = BigUint::from(9u8); // 3 times 3 because already merged one step
    let mut mrg = BigUint::from(3u8);
    let mut x532 = BigUint::from(2u8);

    let mut i = 0usize; let mut j = 1usize;
    let mut c = 1usize;
    while c < n { // satisfy borrow checker with extra blocks: {  }
        if &x532 < &mrg { h[c] = x532; i += 1; x532 = &two * &h[i]; }
        else {	h[c] = mrg;
                if &x53 < &x5 { mrg = x53; j += 1; x53 = &three * &m[j]; }
                else { mrg = x5.clone(); x5 = &five * &x5; };
                m.push(mrg.clone()); };
        c += 1;
    }
    match h.pop() {
        Some(v) => v,
        _ => panic!("nodups_hamming: arg is zero; no elements")
    }
}
