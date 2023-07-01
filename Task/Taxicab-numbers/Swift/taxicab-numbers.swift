extension Array {
  func combinations(_ k: Int) -> [[Element]] {
    return Self._combinations(slice: self[startIndex...], k)
  }

  static func _combinations(slice: Self.SubSequence, _ k: Int) -> [[Element]] {
    guard k != 1 else {
      return slice.map({ [$0] })
    }

    guard k != slice.count else {
      return [slice.map({ $0 })]
    }

    let chopped = slice[slice.index(after: slice.startIndex)...]

    var res = _combinations(slice: chopped, k - 1).map({ [[slice.first!], $0].flatMap({ $0 }) })

    res += _combinations(slice: chopped, k)

    return res
  }
}

let cubes = (1...).lazy.map({ $0 * $0 * $0 })
let taxis =
  Array(cubes.prefix(1201))
    .combinations(2)
    .reduce(into: [Int: [[Int]]](), { $0[$1[0] + $1[1], default: []].append($1) })


let res =
  taxis
    .lazy
    .filter({ $0.value.count > 1 })
    .sorted(by: { $0.key < $1.key })
    .map({ ($0.key, $0.value) })
    .prefix(2006)

print("First 25 taxicab numbers:")
for taxi in res[..<25] {
  print(taxi)
}

print("\n2000th through 2006th taxicab numbers:")
for taxi in res[1999..<2006] {
  print(taxi)
}
