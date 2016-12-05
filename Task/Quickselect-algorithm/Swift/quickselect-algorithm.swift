func select<T where T : Comparable>(var elements: [T], n: Int) -> T {
  var r = indices(elements)
  while true {
    let pivotIndex = partition(&elements, r)
    if n == pivotIndex {
      return elements[pivotIndex]
    } else if n < pivotIndex {
      r.endIndex = pivotIndex
    } else {
      r.startIndex = pivotIndex+1
    }
  }
}

for i in 0 ..< 10 {
  let a = [9, 8, 7, 6, 5, 0, 1, 2, 3, 4]
  print(select(a, i))
  if i < 9 { print(", ") }
}
println()
