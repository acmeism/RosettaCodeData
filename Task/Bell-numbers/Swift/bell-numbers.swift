public struct BellTriangle<T: BinaryInteger> {
  @usableFromInline
  var arr: [T]

  @inlinable
  public internal(set) subscript(row row: Int, col col: Int) -> T {
    get { arr[row * (row - 1) / 2 + col] }
    set { arr[row * (row - 1) / 2 + col] = newValue }
  }

  @inlinable
  public init(n: Int) {
    arr = Array(repeating: 0, count: n * (n + 1) / 2)

    self[row: 1, col: 0] = 1

    for i in 2...n {
      self[row: i, col: 0] = self[row: i - 1, col: i - 2]

      for j in 1..<i {
        self[row: i, col: j] = self[row: i, col: j - 1] + self[row: i - 1, col: j - 1]
      }
    }
  }
}

let tri = BellTriangle<Int>(n: 15)

print("First 15 Bell numbers:")

for i in 1...15 {
  print("\(i): \(tri[row: i, col: 0])")
}

for i in 1...10 {
  print(tri[row: i, col: 0], terminator: "")

  for j in 1..<i {
    print(", \(tri[row: i, col: j])", terminator: "")
  }

  print()
}
