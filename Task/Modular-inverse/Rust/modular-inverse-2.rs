fn modinv(a0: isize, m0: isize) -> isize {
    if m0 == 1 { return 1 }

    let (mut a, mut m, mut x0, mut inv) = (a0, m0, 0, 1);

    while a > 1 {
        inv -= (a / m) * x0;
        a = a % m;
        std::mem::swap(&mut a, &mut m);
        std::mem::swap(&mut x0, &mut inv);
    }

    if inv < 0 { inv += m0 }
    inv
}

fn main() {
  println!("{}", modinv(42, 2017))
}
