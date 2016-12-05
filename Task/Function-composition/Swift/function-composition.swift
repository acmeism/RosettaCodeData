func compose<A,B,C>(f: (B) -> C, g: (A) -> B) -> (A) -> C {
  return { f(g($0)) }
}

let sin_asin = compose(sin, asin)
println(sin_asin(0.5))
