const DIGITS: [char;62] = ['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'];


fn main() {
  let nums_and_bases: [(i64,i64);5] = [(10,-2),(146,-3),(15,-10),(-6222885,-62),(1488588316238,-62)];

  for (n,b) in nums_and_bases.iter() {
    let ns = encode_neg_base(*n, *b);
    println!("{} encoded in base {} = {}", *n, *b, &ns);
    let nn = decode_neg_base(&ns, *b);
    println!("{} decoded in base {} = {}\n", &ns, *b, nn);
  }
}

fn decode_neg_base(ns: &str, b: i64) -> i64 {
    if b < -62 || b > -1 {
        panic!("base must be between -62 and -1 inclusive")
    }
    if ns == "0" {
        return 0
    }
    let mut total: i64 = 0;
    let mut bb: i64 = 1;
    for c in ns.chars().rev() {
        total += (DIGITS.iter().position(|&d| d==c).unwrap() as i64) * bb;
        bb *= b;
    }
    return total;
}

fn encode_neg_base(mut n: i64, b: i64) -> String {
  if b < -62 || b > -1 {
    panic!("base must be between -62 and -1 inclusive");
  }
  if n == 0 {
      return "0".to_string();
  }
  let mut out = String::new();
  while n != 0 {
    let mut rem = n % b;
      n /= b;
      if rem < 0 {
          n+=1;
          rem -= b;
      }
      out.push(DIGITS[rem as usize]);
  }
  return out.chars().rev().collect();
}
