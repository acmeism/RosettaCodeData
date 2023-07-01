func powersetFrom<T>(_ elements: Set<T>) -> Set<Set<T>> {
  guard elements.count > 0 else {
    return [[]]
  }
  var powerset: Set<Set<T>> = [[]]
  for element in elements {
    for subset in powerset {
      powerset.insert(subset.union([element]))
    }
  }
  return powerset
}

// Example:
powersetFrom([1, 2, 4])
