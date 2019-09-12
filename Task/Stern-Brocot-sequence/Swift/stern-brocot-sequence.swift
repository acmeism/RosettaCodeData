struct SternBrocot: Sequence, IteratorProtocol {
  private var seq = [1, 1]

  mutating func next() -> Int? {
    seq += [seq[0] + seq[1], seq[1]]

    return seq.removeFirst()
  }
}

func gcd<T: BinaryInteger>(_ a: T, _ b: T) -> T {
  guard a != 0 else {
    return b
  }

  return a < b ? gcd(b % a, a) : gcd(a % b, b)
}

print("First 15: \(Array(SternBrocot().prefix(15)))")

var found = Set<Int>()

for (i, val) in SternBrocot().enumerated() {
  switch val {
  case 1...10 where !found.contains(val), 100 where !found.contains(val):
    print("First \(val) at \(i + 1)")
    found.insert(val)
  case _:
    continue
  }

  if found.count == 11 {
    break
  }
}

let firstThousand = SternBrocot().prefix(1000)
let gcdIsOne = zip(firstThousand, firstThousand.dropFirst()).allSatisfy({ gcd($0.0, $0.1) == 1 })

print("GCDs of all two consecutive members are \(gcdIsOne ? "" : "not")one")
