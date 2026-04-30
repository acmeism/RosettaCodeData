pub fn main() {
  let _ = echo is_luhn(49_927_398_716) // True
  let _ = echo is_luhn(49_927_398_717) // False
  let _ = echo is_luhn(1_234_567_812_345_678) // False
  let _ = echo is_luhn(1_234_567_812_345_670) // True
}

pub fn is_luhn(n: Int) -> Bool {
  is_luhn_loop(n, 0, True)
}

fn is_luhn_loop(n, sum, even_digit) {
  case n, even_digit {
    0, _ -> sum % 10 == 0
    _, True -> is_luhn_loop(n / 10, sum + n % 10, False)
    _, False -> {
      let x = n % 10
      let y = case x < 5 {
        True -> x + x
        False -> x + x - 9
      }
      is_luhn_loop(n / 10, sum + y, True)
    }
  }
}
