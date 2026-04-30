pub fn fib(n: Int) -> Int {
  case n {
    0 -> 0
    1 -> 1
    n -> fib(n - 1) + fib(n - 2)
  }
}
