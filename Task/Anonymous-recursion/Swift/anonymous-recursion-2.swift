let fib: Int -> Int = {
  var f: (Int -> Int)!
  f = { n in
    assert(n >= 0, "fib: no negative numbers")
    return n < 2 ? 1 : f(n-1) + f(n-2)
  }
  return f
}()

println(fib(8))
