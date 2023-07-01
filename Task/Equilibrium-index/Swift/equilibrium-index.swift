extension Collection where Element: Numeric {
  func equilibriumIndexes() -> [Index] {
    guard !isEmpty else {
      return []
    }

    let sumAll = reduce(0, +)
    var ret = [Index]()
    var sumLeft: Element = 0
    var sumRight: Element

    for i in indices {
      sumRight = sumAll - sumLeft - self[i]

      if sumLeft == sumRight {
        ret.append(i)
      }

      sumLeft += self[i]
    }

    return ret
  }
}

let arr = [-7, 1, 5, 2, -4, 3, 0]

print("Equilibrium indexes of \(arr): \(arr.equilibriumIndexes())")
