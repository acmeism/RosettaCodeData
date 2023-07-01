curry   <- \(f) \(x) \(y) f(x, y)
uncurry <- \(f) \(x, y) f(x)(y)
