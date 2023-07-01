import BigInt
import Foundation

extension BinaryInteger {
  @inlinable
  public var isSquare: Bool {
    var x = self / 2
    var seen = Set([x])

    while x * x != self {
      x = (x + (self / x)) / 2

      if seen.contains(x) {
        return false
      }

      seen.insert(x)
    }

    return true
  }

  @inlinable
  public var isSquareFree: Bool {
    return factors().dropFirst().reduce(true, { $0 && !$1.isSquare })
  }

  @inlinable
  public func factors() -> [Self] {
    let maxN = Self(Double(self).squareRoot())
    var res = Set<Self>()

    for factor in stride(from: 1, through: maxN, by: 1) where self % factor == 0 {
      res.insert(factor)
      res.insert(self / factor)
    }

    return res.sorted()
  }
}

let sqFree1to145 = (1...145).filter({ $0.isSquareFree })

print("Square free numbers in range 1...145: \(sqFree1to145)")

let sqFreeBig = (BigInt(1_000_000_000_000)...BigInt(1_000_000_000_145)).filter({ $0.isSquareFree })

print("Square free numbers in range 1_000_000_000_000...1_000_000_000_045: \(sqFreeBig)")

var count = 0

for n in 1...1_000_000 {
  if n.isSquareFree {
    count += 1
  }

  switch n {
  case 100, 1_000, 10_000, 100_000, 1_000_000:
    print("Square free numbers between 1...\(n): \(count)")
  case _:
    break
  }
}
