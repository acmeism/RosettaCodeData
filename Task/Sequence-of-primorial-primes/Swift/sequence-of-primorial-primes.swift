import BigInt
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

let limit = 20
var primorial = 1
var count = 1
var p = 3
var prod = BigInt(2)

print(1, terminator: " ")

while true {
  defer {
    p += 2
  }

  guard p.isPrime else {
    continue
  }

  prod *= BigInt(p)
  primorial += 1

  if (prod + 1).isPrime() || (prod - 1).isPrime() {
    print(primorial, terminator: " ")

    count += 1

    fflush(stdout)

    if count == limit {
      break
    }
  }
}
