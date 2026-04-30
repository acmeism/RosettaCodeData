pub fn sum_digits(n: Int) -> Int {
  sum_digits_base(n, 10)
}

pub fn sum_digits_base(n: Int, base: Int) -> Int {
  sum_digits_helper(n, base, 0)
}

fn sum_digits_helper(n: Int, base: Int, acc: Int) -> Int {
  case n, base, acc {
    0, _, acc -> acc
    n, base, acc if n < base -> acc + n
    n, base, acc -> sum_digits_helper(n / base, base, acc + { n % base })
  }
}

pub fn main() {
  echo sum_digits(1)
  echo sum_digits(1234)
  echo sum_digits_base(0xfe, 16)
  echo sum_digits_base(0xf0e, 16)
}
