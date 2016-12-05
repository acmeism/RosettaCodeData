func dot(v1: [Double], v2: [Double]) -> Double {
  return reduce(lazy(zip(v1, v2)).map(*), 0, +)
}

println(dot([1, 3, -5], [4, -2, -1]))
