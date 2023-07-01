import Foundation

extension BinaryInteger {
  @inlinable
  public var isPrime: Bool {
    if self == 0 || self == 1 {
      return false
    } else if self == 2 {
      return true
    }

    let max = Self(ceil((Double(self).squareRoot())))

    for i in stride(from: 2, through: max, by: 1) where self % i == 0  {
      return false
    }

    return true
  }
}

public func populationCount(n: Int) -> Int {
  guard n >= 0 else {
      return 0
  }

  return String(n, radix: 2).lazy.filter({ $0 == "1" }).count
}

let first25 = (1...).lazy.filter({ populationCount(n: $0).isPrime }).prefix(25)
let rng = (888_888_877...888_888_888).lazy.filter({ populationCount(n: $0).isPrime })

print("First 25 Pernicious numbers: \(Array(first25))")
print("Pernicious numbers between 888_888_877...888_888_888: \(Array(rng))")
