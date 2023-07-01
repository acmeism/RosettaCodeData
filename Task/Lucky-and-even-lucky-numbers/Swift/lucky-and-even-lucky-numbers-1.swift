struct LuckyNumbers : Sequence, IteratorProtocol {
  let even: Bool
  let through: Int

  private var drainI = 0
  private var n = 0
  private var lst: [Int]

  init(even: Bool = false, through: Int = 1_000_000) {
    self.even = even
    self.through = through
    self.lst = Array(stride(from: even ? 2 : 1, through: through, by: 2))
  }

  mutating func next() -> Int? {
    guard n != 0 else {
      defer { n += 1 }

      return lst[0]
    }

    while n < lst.count && lst[n] < lst.count {
      let retVal = lst[n]

      lst = lst.enumerated().filter({ ($0.offset + 1) % lst[n] != 0  }).map({ $0.element })
      n += 1

      return retVal
    }

    if drainI == 0 {
      lst = Array(lst.dropFirst(n))
    }

    while drainI < lst.count {
      defer { drainI += 1 }

      return lst[drainI]
    }

    return nil
  }
}
