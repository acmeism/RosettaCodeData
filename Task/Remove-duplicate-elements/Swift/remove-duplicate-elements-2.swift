func uniq<T: Hashable>(lst: [T]) -> [T] {
  var seen = Set<T>(minimumCapacity: lst.count)
  return lst.filter { x in
    let unseen = !seen.contains(x)
    seen.insert(x)
    return unseen
  }
}

println(uniq([3,2,1,2,3,4]))
