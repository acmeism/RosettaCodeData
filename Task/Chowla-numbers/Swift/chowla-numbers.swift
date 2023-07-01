import Foundation

@inlinable
public func chowla<T: BinaryInteger>(n: T) -> T {
  stride(from: 2, to: T(Double(n).squareRoot()+1), by: 1)
    .lazy
    .filter({ n % $0 == 0 })
    .reduce(0, {(s: T, m: T) in
      m*m == n ? s + m : s + m + (n / m)
    })
}

extension Dictionary where Key == ClosedRange<Int> {
  subscript(n: Int) -> Value {
    get {
      guard let key = keys.first(where: { $0.contains(n) }) else {
        fatalError("dict does not contain range for \(n)")
      }

      return self[key]!
    }

    set {
      guard let key = keys.first(where: { $0.contains(n) }) else {
        fatalError("dict does not contain range for \(n)")
      }

      self[key] = newValue
    }
  }
}

let lock = DispatchSemaphore(value: 1)

var perfect = [Int]()
var primeCounts = [
  1...100: 0,
  101...1_000: 0,
  1_001...10_000: 0,
  10_001...100_000: 0,
  100_001...1_000_000: 0,
  1_000_001...10_000_000: 0
]

for i in 1...37 {
  print("chowla(\(i)) = \(chowla(n: i))")
}

DispatchQueue.concurrentPerform(iterations: 35_000_000) {i in
  let chowled = chowla(n: i)

  if chowled == 0 && i > 1 && i < 10_000_000 {
    lock.wait()
    primeCounts[i] += 1
    lock.signal()
  }

  if chowled == i - 1 && i > 1 {
    lock.wait()
    perfect.append(i)
    lock.signal()
  }
}

let numPrimes = primeCounts
  .sorted(by: { $0.key.lowerBound < $1.key.lowerBound })
  .reduce(into: [(Int, Int)](), {counts, oneCount in
    guard !counts.isEmpty else {
      counts.append((oneCount.key.upperBound, oneCount.value))

      return
    }

    counts.append((oneCount.key.upperBound, counts.last!.1 + oneCount.value))
  })

for (upper, count) in numPrimes {
  print("Number of primes < \(upper) = \(count)")
}

for p in perfect {
  print("\(p) is a perfect number")
}
