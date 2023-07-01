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

    for i in stride(from: 2, through: max, by: 1) {
      if self % i == 0 {
        return false
      }
    }

    return true
  }
}

@inlinable
public func carmichael<T: BinaryInteger & SignedNumeric>(p1: T) -> [(T, T, T)] {
  func mod(_ n: T, _ m: T) -> T { (n % m + m) % m }

  var res = [(T, T, T)]()

  guard p1.isPrime else {
    return res
  }

  for h3 in stride(from: 2, to: p1, by: 1) {
    for d in stride(from: 1, to: h3 + p1, by: 1) {
      if (h3 + p1) * (p1 - 1) % d != 0 || mod(-p1 * p1, h3) != d % h3 {
        continue
      }

      let p2 = 1 + (p1 - 1) * (h3 + p1) / d

      guard p2.isPrime else {
        continue
      }

      let p3 = 1 + p1 * p2 / h3

      guard p3.isPrime && (p2 * p3) % (p1 - 1) == 1 else {
        continue
      }

      res.append((p1, p2, p3))
    }
  }

  return res
}


let res =
  (1..<62)
    .lazy
    .filter({ $0.isPrime })
    .map(carmichael)
    .filter({ !$0.isEmpty })
    .flatMap({ $0 })

for c in res {
  print(c)
}
