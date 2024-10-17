fn palindromicgapfuls(digit: u64, count: u64, keep: usize) -> Vec<u64> {
  let mut palcnt = 0u64;               // count of gapful palindromes
  let to_skip = count - keep as u64;   // count of unwanted values to skip
  let mut gapfuls: Vec<u64> = vec![];  // array of palindromic gapfuls
  let nn = digit * 11;                 // digit gapful divisor: 11, 22,...88, 99
  let (mut power, mut base) = (1, 1u64);
  loop { power += 1;
    if power & 1 == 0 { base *= 10 };  // value of middle digit position: 10..
    let base11  = base * 11;           // value of middle two digits positions: 110..
    let this_lo = base * digit;        // starting half for this digit: 10.. to  90..
    let next_lo = base * (digit + 1);  // starting half for next digit: 20.. to 100..
    for front_half in (this_lo..next_lo-1).step_by(10) { // d_00; d_10; d_20; ...
      let (mut left_half, mut basep) = (front_half.to_string(), 0);
      let right_half = left_half.chars().rev().collect::<String>();
      if power & 1 == 1 { basep = base11; left_half.push_str(&right_half) }
      else              { basep = base;   left_half.pop(); left_half.push_str(&right_half) };
      let mut palindrome = left_half.parse::<u64>().unwrap();
      for _ in 0..10 {
        if palindrome % nn == 0 { palcnt += 1; if palcnt > to_skip { gapfuls.push(palindrome) } };
        palindrome += basep;
      }
      if gapfuls.len() >= keep { return gapfuls[0..keep].to_vec() };
    }
  }
}

fn main() {
  let t = std::time::Instant::now();

  let (count, keep) = (20, 20);
  println!("First 20 palindromic gapful numbers ending with:");
  for digit in 1..10 { println!("{} : {:?}", digit, palindromicgapfuls(digit, count, keep)); }

  let (count, keep) = (100, 15);
  println!("\nLast 15 of first 100 palindromic gapful numbers ending in:");
  for digit in 1..10 { println!("{} : {:?}", digit, palindromicgapfuls(digit, count, keep)); }

  let (count, keep) = (1_000, 10);
  println!("\nLast 10 of first 1000 palindromic gapful numbers ending in:");
  for digit in 1..10 { println!("{} : {:?}", digit, palindromicgapfuls(digit, count, keep)); }

  let (count, keep) = (100_000, 1);
  println!("\n100,000th palindromic gapful number ending with:");
  for digit in 1..10 { println!("{} : {:?}", digit, palindromicgapfuls(digit, count, keep)); }

  let (count, keep) = (1_000_000, 1);
  println!("\n1,000,000th palindromic gapful number ending with:");
  for digit in 1..10 { println!("{} : {:?}", digit, palindromicgapfuls(digit, count, keep)); }

  let (count, keep) = (10_000_000, 1);
  println!("\n10,000,000th palindromic gapful number ending with:");
  for digit in 1..10 { println!("{} : {:?}", digit, palindromicgapfuls(digit, count, keep)); }

  println!("{:?}", t.elapsed())
}
