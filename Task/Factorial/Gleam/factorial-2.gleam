pub fn fac(n: Int) -> Int {
  case n {
    1 -> 1
    n -> n * fac(n - 1)
  }
}
