struct SplitMix64: RandomNumberGenerator {
    var state: UInt64
    init(seed: UInt64) {
        state = seed
    }
    mutating func next() -> UInt64 {
        state &+= 0x9e3779b97f4a7c15
        var z = state
        z = (z ^ (z >> 30)) &* 0xbf58476d1ce4e5b9
        z = (z ^ (z >> 27)) &* 0x94d049bb133111eb
        return z ^ (z >> 31)
    }
    mutating func nextFloat() -> Float64 {
        Float64(next() >> 11) * 0x1.0p-53
    }
}

do {
    var split = SplitMix64(seed: 1234567)
    print(split)
    for _ in 0..<5 {
        print(split.next())
    }
    split = .init(seed: 987654321)
    print("\n\(split)")
    var counts = [0, 0, 0, 0, 0]
    for _ in 0..<100_000 {
        let i = Int(split.nextFloat() * 5.0)
        counts[i] += 1
    }
    for (i, count) in zip(0..., counts) {
        print("\(i): \(count)")
    }
}
