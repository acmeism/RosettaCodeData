fn is_prime(num: u32) -> bool {
  match num {
      x if x < 4 => x > 1,
      x if x % 2 == 0 => false,
      x => { let limit = (x as f32).sqrt().ceil() as u32;
              (3..=limit).step_by(2).all(|a| x % a != 0)
            }
  }
}

fn primes_by_diffs(primes: &[u32], diffs: &[u32]) -> Vec<Vec<u32>> {

  fn select(diffs: &[u32], prime_win: &[u32], acc: bool) -> bool {
    if diffs.is_empty() || !acc {
      acc
    }
    else {
      let acc1 = prime_win[0] + diffs[0] == prime_win[1];
      select(&diffs[1..], &prime_win[1..], acc1)
    }
  }

  primes.windows(diffs.len() + 1)
        .filter(|&win| select(diffs, win, true))
        .map(|win| win.to_vec())
        .collect()
}

fn main() {
  let limit = 1_000_000u32;
  let start = std::time::Instant::now();
  let primes = (2..).filter(|&i| is_prime(i));
  let prime_list: Vec<u32> = primes.take_while(|&p| p <= limit).collect();
  let duration = start.elapsed();
  println!("primes time: {:?}", duration);
  for diffs in vec!(vec!(1), vec!(2), vec!(2,2), vec!(2,4), vec!(4,2), vec!(6,4,2), vec!(2,4,6)) {
    let result_list = primes_by_diffs(&prime_list, &diffs);
    let len = result_list.len();
    println!("{:?} number: {}\n\tfirst: {:?}", diffs, len, result_list[0]);
    if len == 1 {
      println!()
    }
    if len > 1 {
      println!("\tlast: {:?}\n", result_list.last().unwrap())
    }
  }
}
