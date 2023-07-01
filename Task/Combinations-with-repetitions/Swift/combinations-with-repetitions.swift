func combosWithRep<T>(var objects: [T], n: Int) -> [[T]] {
  if n == 0 { return [[]] } else {
    var combos = [[T]]()
    while let element = objects.last {
      combos.appendContentsOf(combosWithRep(objects, n: n - 1).map{ $0 + [element] })
      objects.removeLast()
    }
    return combos
  }
}
print(combosWithRep(["iced", "jam", "plain"], n: 2).map {$0.joinWithSeparator(" and ")}.joinWithSeparator("\n"))
