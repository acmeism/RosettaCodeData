import BigInt
import Foundation

extension BinaryInteger {
  @inlinable
  public func primeDecomposition() -> [Self] {
    guard self > 1 else { return [] }

    func step(_ x: Self) -> Self {
      return 1 + (x << 2) - ((x >> 1) << 1)
    }

    let maxQ = Self(Double(self).squareRoot())
    var d: Self = 1
    var q: Self = self & 1 == 0 ? 2 : 3

    while q <= maxQ && self % q != 0 {
      q = step(d)
      d += 1
    }

    return q <= maxQ ? [q] + (self / q).primeDecomposition() : [self]
  }
}

let numbers = [
  112272537195293,
  112582718962171,
  112272537095293,
  115280098190773,
  115797840077099,
  1099726829285419,
  1275792312878611,
  BigInt("64921987050997300559")
]

func findLargestMinFactor<T: BinaryInteger>(for nums: [T], then: @escaping ((n: T, factors: [T])) -> ()) {
  let waiter = DispatchSemaphore(value: 0)
  let lock = DispatchSemaphore(value: 1)
  var factors = [(n: T, factors: [T])]()

  DispatchQueue.concurrentPerform(iterations: nums.count) {i in
    let n = nums[i]

    print("Factoring \(n)")

    let nFacs = n.primeDecomposition().sorted()

    print("Factored \(n)")

    lock.wait()
    factors.append((n, nFacs))

    if factors.count == nums.count {
      waiter.signal()
    }

    lock.signal()
  }

  waiter.wait()

  then(factors.sorted(by: { $0.factors.first! > $1.factors.first! }).first!)
}

findLargestMinFactor(for: numbers) {res in
  let (n, factors) = res

  print("Number with largest min prime factor: \(n); factors: \(factors)")

  exit(0)
}

dispatchMain()
