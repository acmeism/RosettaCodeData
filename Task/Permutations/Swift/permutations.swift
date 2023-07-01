func perms<T>(var ar: [T]) -> [[T]] {
  return heaps(&ar, ar.count)
}

func heaps<T>(inout ar: [T], n: Int) -> [[T]] {
  return n == 1 ? [ar] :
    Swift.reduce(0..<n, [[T]]()) {
      (var shuffles, i) in
      shuffles.extend(heaps(&ar, n - 1))
      swap(&ar[n % 2 == 0 ? i : 0], &ar[n - 1])
      return shuffles
  }
}

perms([1, 2, 3]) // [[1, 2, 3], [2, 1, 3], [3, 1, 2], [1, 3, 2], [2, 3, 1], [3, 2, 1]]
