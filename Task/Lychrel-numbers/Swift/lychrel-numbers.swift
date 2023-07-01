import BigInt

public struct Lychrel<T: ReversibleNumeric & CustomStringConvertible>: Sequence, IteratorProtocol {
  @usableFromInline
  let seed: T

  @usableFromInline
  var done = false

  @usableFromInline
  var n: T

  @usableFromInline
  var iterations: T

  @inlinable
  public init(seed: T, iterations: T = 500) {
    self.seed = seed
    self.n = seed
    self.iterations = iterations
  }

  @inlinable
  public mutating func next() -> T? {
    guard !done && iterations != 0 else {
      return nil
    }

    guard !isPalindrome(n) || n == seed else {
      done = true

      return n
    }

    defer {
      n += n.reversed()
      iterations -= 1
    }

    return n
  }
}

@inlinable
public func isPalindrome<T: CustomStringConvertible>(_ x: T) -> Bool {
  let asString = String(describing: x)

  for (c, c1) in zip(asString, asString.reversed()) where c != c1 {
    return false
  }

  return true
}

public protocol ReversibleNumeric: Numeric {
  func reversed() -> Self
}

extension BigInt: ReversibleNumeric {
  public func reversed() -> BigInt {
    return BigInt(String(description.reversed()))!
  }
}

typealias LychrelReduce = (seen: Set<BigInt>, seeds: Set<BigInt>, related: Set<BigInt>)

let (seen, seeds, related): LychrelReduce =
  (1...10_000)
    .map({ BigInt($0) })
    .reduce(into: LychrelReduce(seen: Set(), seeds: Set(), related: Set()), {res, cur in
      guard !res.seen.contains(cur) else {
        res.related.insert(cur)

        return
      }

      var seen = false

      let seq = Lychrel(seed: cur).prefix(while: { seen = res.seen.contains($0); return !seen })
      let last = seq.last!

      guard !isPalindrome(last) || seen else {
        return
      }

      res.seen.formUnion(seq)

      if seq.count == 500 {
        res.seeds.insert(cur)
      } else {
        res.related.insert(cur)
      }
  })

print("Found \(seeds.count + related.count) Lychrel numbers between 1...10_000 when limited to 500 iterations")
print("Number of Lychrel seeds found: \(seeds.count)")
print("Lychrel seeds found: \(seeds.sorted())")
print("Number of related Lychrel nums found: \(related.count)")
print("Lychrel palindromes found: \(seeds.union(related).filter(isPalindrome).sorted())")
