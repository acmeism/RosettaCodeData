fn fact(n:u32) -> u64 {
  let mut f:u64 = n as u64;
  for i in 2..n {
    f *= i as u64;
  }
  return f;
}

fn choose(n: u32, k: u32)  -> u64 {
   let mut num:u64 = n as u64;
   for i in 1..k {
     num *= (n-i) as u64;
   }
   return num / fact(k);
}

fn main() {
  println!("{}", choose(5,3));
}
