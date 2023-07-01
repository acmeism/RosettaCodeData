import Foundation

extension Numeric where Self: Strideable {
  @inlinable
  public func power(_ n: Self) -> Self {
    return stride(from: 0, to: n, by: 1).lazy.map({_ in self }).reduce(1, *)
  }
}

func eratosthenes(limit: Int) -> [Int] {
  guard limit >= 3 else {
    return limit < 2 ? [] : [2]
  }

  let ndxLimit = (limit - 3) / 2 + 1
  let bufSize = ((limit - 3) / 2) / 32 + 1
  let sqrtNdxLimit = (Int(Double(limit).squareRoot()) - 3) / 2 + 1
  var cmpsts = Array(repeating: 0, count: bufSize)

  for ndx in 0..<sqrtNdxLimit where (cmpsts[ndx >> 5] & (1 << (ndx & 31))) == 0 {
    let p = ndx + ndx + 3
    var cullPos = (p * p - 3) / 2

    while cullPos < ndxLimit {
      cmpsts[cullPos >> 5] |= 1 << (cullPos & 31)

      cullPos += p
    }
  }

  return (-1..<ndxLimit).compactMap({i -> Int? in
    if i < 0 {
      return 2
    } else {
      if cmpsts[i >> 5] & (1 << (i & 31)) == 0 {
        return .some(i + i + 3)
      } else {
        return nil
      }
    }
  })
}

let primes = eratosthenes(limit: 1_000_000_000)

func φ(_ x: Int, _ a: Int) -> Int {
  struct Cache {
    static var cache = [String: Int]()
  }

  guard a != 0 else {
    return x
  }

  guard Cache.cache["\(x),\(a)"] == nil else {
    return Cache.cache["\(x),\(a)"]!
  }

  Cache.cache["\(x),\(a)"] = φ(x, a - 1) - φ(x / primes[a - 1], a - 1)

  return Cache.cache["\(x),\(a)"]!
}

func π(n: Int) -> Int {
  guard n > 2 else {
    return 0
  }

  let a = π(n: Int(Double(n).squareRoot()))

  return φ(n, a) + a - 1
}

for i in 0..<10 {
  let n = 10.power(i)

  print("π(10^\(i)) = \(π(n: n))")
}
