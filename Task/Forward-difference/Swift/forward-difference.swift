func forwardsDifference<T: SignedNumeric>(of arr: [T]) -> [T] {
  return zip(arr.dropFirst(), arr).map({ $0.0 - $0.1 })
}

func nthForwardsDifference<T: SignedNumeric>(of arr: [T], n: Int) -> [T] {
  assert(n >= 0)

  switch (arr, n) {
  case ([], _):
    return []
  case let (arr, 0):
    return arr
  case let (arr, i):
    return nthForwardsDifference(of: forwardsDifference(of: arr), n: i - 1)
  }
}

for diff in (0...9).map({ nthForwardsDifference(of: [90, 47, 58, 29, 22, 32, 55, 5, 55, 73], n: $0) }) {
  print(diff)
}
