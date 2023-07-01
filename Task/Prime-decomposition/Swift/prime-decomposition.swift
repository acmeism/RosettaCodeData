func primeDecomposition<T: BinaryInteger>(of n: T) -> [T] {
  guard n > 2 else { return [] }

  func step(_ x: T) -> T {
    return 1 + (x << 2) - ((x >> 1) << 1)
  }

  let maxQ = T(Double(n).squareRoot())
  var d: T = 1
  var q: T = n % 2 == 0 ? 2 : 3

  while q <= maxQ && n % q != 0 {
    q = step(d)
    d += 1
  }

  return q <= maxQ ? [q] + primeDecomposition(of: n / q) : [n]
}

for prime in Eratosthenes(upTo: 60) {
  let m = Int(pow(2, Double(prime))) - 1
  let decom = primeDecomposition(of: m)

  print("2^\(prime) - 1 = \(m) => \(decom)")
}
