func makeAccumulator(var sum: Double) -> Double -> Double {
  return {
    sum += $0
    return sum
  }
}

let x = makeAccumulator(1)
x(5)
let _ = makeAccumulator(3)
println(x(2.3))
