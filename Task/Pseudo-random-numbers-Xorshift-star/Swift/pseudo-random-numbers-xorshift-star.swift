import Foundation

struct XorshiftStar {
  private let magic: UInt64 = 0x2545F4914F6CDD1D
  private var state: UInt64

  init(seed: UInt64) {
    state = seed
  }

  mutating func nextInt() -> UInt64 {
    state ^= state &>> 12
    state ^= state &<< 25
    state ^= state &>> 27

    return (state &* magic) &>> 32
  }

  mutating func nextFloat() -> Float {
    return Float(nextInt()) / Float(1 << 32)
  }
}

extension XorshiftStar: RandomNumberGenerator, IteratorProtocol, Sequence {
  mutating func next() -> UInt64 {
    return nextInt()
  }

  mutating func next() -> UInt64? {
    return nextInt()
  }
}

for (i, n) in XorshiftStar(seed: 1234567).lazy.enumerated().prefix(5) {
  print("\(i): \(n)")
}

var gen = XorshiftStar(seed: 987654321)
var counts = [Float: Int]()

for _ in 0..<100_000 {
  counts[floorf(gen.nextFloat() * 5), default: 0] += 1
}

print(counts)
