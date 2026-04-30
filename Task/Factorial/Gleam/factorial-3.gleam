pub fn fac(n: Int) -> Int {
  fac_helper(n, n - 1)
}

fn fac_helper(n: Int, acc: Int) -> Int {
  case n, acc {
    n, 1 -> n
    n, i -> fac_helper(n * i, i - 1)
  }
}
