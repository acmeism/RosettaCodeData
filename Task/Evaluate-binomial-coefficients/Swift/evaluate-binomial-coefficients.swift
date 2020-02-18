func factorial<T: BinaryInteger>(_ n: T) -> T {
  guard n != 0 else {
    return 1
  }

  return stride(from: n, to: 0, by: -1).reduce(1, *)
}

func binomial<T: BinaryInteger>(_ x: (n: T, k: T)) -> T {
  let nFac = factorial(x.n)
  let kFac = factorial(x.k)

  return nFac / (factorial(x.n - x.k) * kFac)
}

print("binomial(\(5), \(3)) = \(binomial((5, 3)))")
print("binomial(\(20), \(11)) = \(binomial((20, 11)))")
