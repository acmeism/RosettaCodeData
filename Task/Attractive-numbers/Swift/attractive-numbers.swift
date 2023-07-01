import Foundation

extension BinaryInteger {
  @inlinable
  public var isAttractive: Bool {
    return primeDecomposition().count.isPrime
  }

  @inlinable
  public var isPrime: Bool {
    if self == 0 || self == 1 {
      return false
    } else if self == 2 {
      return true
    }

    let max = Self(ceil((Double(self).squareRoot())))

    for i in stride(from: 2, through: max, by: 1) {
      if self % i == 0 {
        return false
      }
    }

    return true
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
}

let attractive = Array((1...).lazy.filter({ $0.isAttractive }).prefix(while: { $0 <= 120 }))

print("Attractive numbers up to and including 120: \(attractive)")
