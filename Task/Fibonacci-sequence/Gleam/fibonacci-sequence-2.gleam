pub fn fib(n: Int) -> Int {
  fib_helper(n, 0, 1)
}

fn fib_helper(n: Int, res: Int, next: Int) -> Int {
  case n, res, next {
    0, res, _ -> res
    iter, res, next -> fib_helper(iter - 1, next, res + next)
  }
}
