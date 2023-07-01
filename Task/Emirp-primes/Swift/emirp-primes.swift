import Foundation

extension BinaryInteger {
  var isPrime: Bool {
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

func isEmirp<T: BinaryInteger>(n: T) -> Bool {
  guard n.isPrime else {
    return false
  }

  var aux = n
  var revPrime = T(0)

  while aux > 0 {
    revPrime = revPrime * 10 + aux % 10
    aux /= 10
  }

  guard n != revPrime else {
    return false
  }

  return revPrime.isPrime
}

let lots = (2...).lazy.filter(isEmirp).prefix(10000)
let rang = (7700...8000).filter(isEmirp)

print("First 20 emirps: \(Array(lots.prefix(20)))")
print("Emirps between 7700 and 8000: \(rang)")
print("10,000th emirp: \(Array(lots).last!)")
