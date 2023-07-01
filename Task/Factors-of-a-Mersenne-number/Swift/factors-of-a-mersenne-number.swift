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

  func modPow(exp: Self, mod: Self) -> Self {
    guard exp != 0 else {
      return 1
    }

    var res = Self(1)
    var base = self % mod
    var exp = exp

    while true {
      if exp & 1 == 1 {
        res *= base
        res %= mod
      }

      if exp == 1 {
        return res
      }

      exp >>= 1
      base *= base
      base %= mod
    }
  }
}

func mFactor(exp: Int) -> Int? {
  for k in 0..<16384 {
    let q = 2*exp*k + 1

    if !q.isPrime {
      continue
    } else if q % 8 != 1 && q % 8 != 7 {
      continue
    } else if 2.modPow(exp: exp, mod: q) == 1 {
      return q
    }
  }

  return nil
}

print(mFactor(exp: 929)!)
