func sumSq(s: [Int]) -> Int {
  return s.map{$0 * $0}.reduce(0, +)
}
