struct FuscSeq: Sequence, IteratorProtocol {
  private var arr = [0, 1]
  private var i = 0

  mutating func next() -> Int? {
    defer {
      i += 1
    }

    guard i > 1 else {
      return arr[i]
    }

    switch i & 1 {
    case 0:
      arr.append(arr[i / 2])
    case 1:
      arr.append(arr[(i - 1) / 2] + arr[(i + 1) / 2])
    case _:
      fatalError()
    }

    return arr.last!
  }
}

let first = FuscSeq().prefix(61)

print("First 61: \(Array(first))")

var max = -1

for (i, n) in FuscSeq().prefix(20_000_000).enumerated() {
  let f = String(n).count

  if f > max {
    max = f

    print("New max: \(i): \(n)")
  }
}
