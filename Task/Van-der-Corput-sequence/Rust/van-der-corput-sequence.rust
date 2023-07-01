/// Van der Corput sequence for any base, based on C languange example from Wikipedia.
pub fn corput(nth: usize, base: usize) -> f64 {
    let mut n = nth;
    let mut q: f64 = 0.0;
    let mut bk: f64 = 1.0 / (base as f64);

    while n > 0_usize {
      q += ((n % base) as f64)*bk;
      n /= base;
      bk /= base as f64;
    }
    q
}

fn main() {
  for base in 2_usize..=5_usize {
    print!("Base {}:", base);
    for i in 1_usize..=10_usize {
      let c = corput(i, base);
      print!("  {:.6}", c)
    }
    println!("");
  }
}
