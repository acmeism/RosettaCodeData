func horner(coefs: [Double], x: Double) -> Double {
  return reduce(lazy(coefs).reverse(), 0) { $0 * x + $1 }
}

println(horner([-19, 7, -4, 6], 3))
