extension Collection where Element: Comparable {
  public func cocktailSorted() -> [Element] {
    var swapped = false
    var ret = Array(self)

    guard count > 1 else {
      return ret
    }

    repeat {
      for i in 0...ret.count-2 where ret[i] > ret[i + 1] {
        (ret[i], ret[i + 1]) = (ret[i + 1], ret[i])
        swapped = true
      }

      guard swapped else {
        break
      }

      swapped = false

      for i in stride(from: ret.count - 2, through: 0, by: -1) where ret[i] > ret[i + 1] {
        (ret[i], ret[i + 1]) = (ret[i + 1], ret[i])
        swapped = true
      }
    } while swapped

    return ret
  }
}

let arr = (1...10).shuffled()

print("Before: \(arr)")
print("Cocktail sort: \(arr.cocktailSorted())")
