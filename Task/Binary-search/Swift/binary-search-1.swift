func binarySearch<T: Comparable>(xs: [T], x: T) -> Int? {
  var recurse: ((Int, Int) -> Int?)!
  recurse = {(low, high) in switch (low + high) / 2 {
    case _ where high < low: return nil
    case let mid where xs[mid] > x: return recurse(low, mid - 1)
    case let mid where xs[mid] < x: return recurse(mid + 1, high)
    case let mid: return mid
  }}
  return recurse(0, xs.count - 1)
}
