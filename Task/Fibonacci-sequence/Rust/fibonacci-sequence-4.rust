fn fib_tail_recursive(nth: usize) -> usize {
  fn fib_tail_iter(n: usize, prev_fib: usize, fib: usize) -> usize {
    match n {
      0 => prev_fib,
      n => fib_tail_iter(n - 1, fib, prev_fib + fib),
    }
  }
  fib_tail_iter(nth, 0, 1)
}
