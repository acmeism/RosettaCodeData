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

func motzkin(_ n: Int) -> [Int] {
  var m = Array(repeating: 0, count: n)

  m[0] = 1
  m[1] = 1

  for i in 2..<n {
    m[i] = (m[i - 1] * (2 * i + 1) + m[i - 2] * (3 * i - 3)) / (i + 2)
  }

  return m
}

let m = motzkin(42)

for (i, n) in m.enumerated() {
  print("\(i): \(n) \(n.isPrime ? "prime" : "")")
}
