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

    for i in stride(from: 2, through: max, by: 1) {
      if self % i == 0 {
        return false
      }
    }

    return true
  }
}

@inlinable
public func smoothN<T: BinaryInteger>(n: T, count: Int) -> [T] {
  let primes = stride(from: 2, to: n + 1, by: 1).filter({ $0.isPrime })
  var next = primes
  var indices = [Int](repeating: 0, count: primes.count)
  var res = [T](repeating: 0, count: count)

  res[0] = 1

  guard count > 1 else {
    return res
  }

  for m in 1..<count {
    res[m] = next.min()!

    for i in 0..<indices.count where res[m] == next[i] {
      indices[i] += 1
      next[i] = primes[i] * res[indices[i]]
    }
  }

  return res
}

for n in 2...29 where n.isPrime {
  print("The first 25 \(n)-smooth numbers are: \(smoothN(n: n, count: 25))")
}

print()

for n in 3...29 where n.isPrime {
  print("The 3000...3002 \(n)-smooth numbers are: \(smoothN(n: BigInt(n), count: 3002).dropFirst(2999).prefix(3))")
}

print()

for n in 503...521 where n.isPrime {
  print("The 30,000...30,019 \(n)-smooth numbers are: \(smoothN(n: BigInt(n), count: 30_019).dropFirst(29999).prefix(20))")
}
