extension Array {
  public mutating func satalloShuffle() {
    for i in stride(from: index(before: endIndex), through: 1, by: -1) {
      swapAt(i, .random(in: 0..<i))
    }
  }

  public func satalloShuffled() -> [Element] {
    var arr = Array(self)

    arr.satalloShuffle()

    return arr
  }
}

let testCases = [
  [],
  [10, 20],
  [10, 20, 30],
  [11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]
]

for testCase in testCases {
  let shuffled = testCase.satalloShuffled()

  guard zip(testCase, shuffled).allSatisfy(!=) else {
    fatalError("satallo shuffle failed")
  }

  print("\(testCase) shuffled = \(shuffled)")
}
