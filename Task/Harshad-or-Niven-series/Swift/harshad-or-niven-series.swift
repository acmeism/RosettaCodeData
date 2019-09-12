struct Harshad: Sequence, IteratorProtocol {
  private var i = 0

  mutating func next() -> Int? {
    while true {
      i += 1

      if i % Array(String(i)).map(String.init).compactMap(Int.init).reduce(0, +) == 0 {
        return i
      }
    }
  }
}

print("First 20: \(Array(Harshad().prefix(20)))")
print("First over a 1000: \(Harshad().first(where: { $0 > 1000 })!)")
