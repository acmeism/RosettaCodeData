func testBinarySearch(n: Int) {
  let odds = Array(stride(from: 1, through: n, by: 2))
  let result = flatMap(0...n) {binarySearch(odds, $0)}
  assert(result == Array(0..<odds.count))
  println("\(odds) are odd natural numbers")
  for it in result {
    println("\(it) is ordinal of \(odds[it])")
  }
}

testBinarySearch(12)

func flatMap<T, U>(source: [T], transform: (T) -> U?) -> [U] {
  return source.reduce([]) {(var xs, x) in if let x = transform(x) {xs.append(x)}; return xs}
}
