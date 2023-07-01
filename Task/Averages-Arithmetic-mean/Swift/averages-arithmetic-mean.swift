func meanDoubles(s: [Double]) -> Double {
  return s.reduce(0, +) / Double(s.count)
}
func meanInts(s: [Int]) -> Double {
  return meanDoubles(s.map{Double($0)})
}
