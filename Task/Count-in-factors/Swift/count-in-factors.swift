extension BinaryInteger {
  @inlinable
  public func primeDecomposition() -> [Self] {
    guard self > 1 else { return [] }

    func step(_ x: Self) -> Self {
      return 1 + (x << 2) - ((x >> 1) << 1)
    }

    let maxQ = Self(Double(self).squareRoot())
    var d: Self = 1
    var q: Self = self & 1 == 0 ? 2 : 3

    while q <= maxQ && self % q != 0 {
      q = step(d)
      d += 1
    }

    return q <= maxQ ? [q] + (self / q).primeDecomposition() : [self]
  }
}

for i in 1...20 {
  if i == 1 {
    print("1 = 1")
  } else {
    print("\(i) = \(i.primeDecomposition().map(String.init).joined(separator: " x "))")
  }
}
