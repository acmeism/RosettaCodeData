func binarySearch<T: Comparable>(xs: [T], x: T) -> Int? {
  var (low, high) = (0, xs.count - 1)
  while low <= high {
    switch (low + high) / 2 {
      case let mid where xs[mid] > x: high = mid - 1
      case let mid where xs[mid] < x: low = mid + 1
      case let mid: return mid
    }
  }
  return nil
}
