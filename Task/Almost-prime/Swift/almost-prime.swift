struct KPrimeGen: Sequence, IteratorProtocol {
  let k: Int
  private(set) var n: Int

  private func isKPrime() -> Bool {
    var primes = 0
    var f = 2
    var rem = n

    while primes < k && rem > 1 {
      while rem % f == 0 && rem > 1 {
        rem /= f
        primes += 1
      }

      f += 1
    }

    return rem == 1 && primes == k
  }

  mutating func next() -> Int? {
    n += 1

    while !isKPrime() {
      n += 1
    }

    return n
  }
}

for k in 1..<6 {
  print("\(k): \(Array(KPrimeGen(k: k, n: 1).lazy.prefix(10)))")
}
