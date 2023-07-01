extension BinaryInteger {
  @inlinable
  public var isSmith: Bool {
    guard self > 3 else {
      return false
    }

    let primeFactors = primeDecomposition()

    guard primeFactors.count != 1 else {
      return false
    }

    return primeFactors.map({ $0.sumDigits() }).reduce(0, +) == sumDigits()
  }

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

  @inlinable
  public func sumDigits() -> Self {
    return String(self).lazy.map({ Self(Int(String($0))!) }).reduce(0, +)
  }
}

let smiths = (0..<10_000).filter({ $0.isSmith })

print("Num Smith numbers below 10,000: \(smiths.count)")
print("First 10 smith numbers: \(Array(smiths.prefix(10)))")
print("Last 10 smith numbers below 10,000: \(Array(smiths.suffix(10)))")
