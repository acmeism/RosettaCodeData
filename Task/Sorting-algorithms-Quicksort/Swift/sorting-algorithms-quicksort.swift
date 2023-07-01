func quicksort<T where T : Comparable>(inout elements: [T], range: Range<Int>) {
  if (range.endIndex - range.startIndex > 1) {
    let pivotIndex = partition(&elements, range)
    quicksort(&elements, range.startIndex ..< pivotIndex)
    quicksort(&elements, pivotIndex+1 ..< range.endIndex)
  }
}

func quicksort<T where T : Comparable>(inout elements: [T]) {
  quicksort(&elements, indices(elements))
}
