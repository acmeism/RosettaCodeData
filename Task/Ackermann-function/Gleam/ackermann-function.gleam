pub fn ackermann(m: Int, n: Int) -> Int {
  case m, n {
    0, n -> n + 1
    m, 0 -> ackermann(m - 1, 1)
    m, n -> ackermann(m - 1, ackermann(m, n - 1))
  }
}

pub fn main() {
  echo ackermann(0, 0)
  echo ackermann(0, 4)
  echo ackermann(1, 0)
  echo ackermann(1, 1)
  echo ackermann(2, 1)
  echo ackermann(2, 2)
  echo ackermann(3, 1)
  echo ackermann(3, 3)
  echo ackermann(4, 0)
  echo ackermann(4, 1)
}
