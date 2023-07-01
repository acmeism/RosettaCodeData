public struct Eratosthenes: Sequence, IteratorProtocol {
  private let n: Int
  private let limit: Int

  private var i = 2
  private var sieve: [Int]

  public init(upTo: Int) {
    if upTo <= 1 {
      self.n = 0
      self.limit = -1
      self.sieve = []
    } else {
      self.n = upTo
      self.limit = Int(Double(n).squareRoot())
      self.sieve = Array(0...n)
    }
  }

  public mutating func next() -> Int? {
    while i < n {
      defer { i += 1 }

      if sieve[i] != 0 {
        if i <= limit {
          for notPrime in stride(from: i * i, through: n, by: i) {
            sieve[notPrime] = 0
          }
        }

        return i
      }
    }

    return nil
  }
}

func findPeriod(n: Int) -> Int {
  let r = (1...n+1).reduce(1, {res, _ in (10 * res) % n })
  var rr = r
  var period = 0

  repeat {
    rr = (10 * rr) % n
    period += 1
  } while r != rr

  return period
}

let longPrimes = Eratosthenes(upTo: 64000).dropFirst().lazy.filter({ findPeriod(n: $0) == $0 - 1 })

print("Long primes less than 500: \(Array(longPrimes.prefix(while: { $0 <= 500 })))")

let counts =
  longPrimes.reduce(into: [500: 0, 1000: 0, 2000: 0, 4000: 0, 8000: 0, 16000: 0, 32000: 0, 64000: 0], {counts, n in
    for key in counts.keys where n < key {
      counts[key]! += 1
    }
  })

for key in counts.keys.sorted() {
  print("There are \(counts[key]!) long primes less than \(key)")
}
