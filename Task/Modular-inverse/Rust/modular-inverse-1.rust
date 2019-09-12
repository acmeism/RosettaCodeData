fn mod_inv(a: isize, module: isize) -> isize {
  let mut mn = (module, a);
  let mut xy = (0, 1);

  while mn.1 != 0 {
    xy = (xy.1, xy.0 - (mn.0 / mn.1) * xy.1);
    mn = (mn.1, mn.0 % mn.1);
  }

  while xy.0 < 0 {
    xy.0 += module;
  }
  xy.0
}

fn main() {
  println!("{}", mod_inv(42, 2017))
}
