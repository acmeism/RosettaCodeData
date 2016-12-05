func uniq<T: Equatable>(lst: [T]) -> [T] {
  var seen = [T]()
  return lst.filter { x in
    let unseen = find(seen, x) == nil
    if (unseen) {
      seen.append(x)
    }
    return unseen
  }
}

println(uniq([3,2,1,2,3,4]))
