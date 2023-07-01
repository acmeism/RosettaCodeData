let fib: Int -> Int = {
  func f(n: Int) -> Int {
    assert(n >= 0, "fib: no negative numbers")
    return n < 2 ? 1 : f(n-1) + f(n-2)
  }
  return f
}()

print(fib(8))
