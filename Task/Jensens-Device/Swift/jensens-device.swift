var i = 42 // initial value doesn't matter

func sum(inout i: Int, lo: Int, hi: Int, @autoclosure term: () -> Double) -> Double {
  var result = 0.0
  for i = lo; i <= hi; i++ {
    result += term()
  }
  return result
}

println(sum(&i, 1, 100, 1 / Double(i)))
