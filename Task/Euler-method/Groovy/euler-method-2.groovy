def dtdsNewton = { s, t, tR, k ->  k * (tR - t) }
assert dtdsNewton.maximumNumberOfParameters == 4

def dtds = dtdsNewton.rcurry(20, 0.07)
assert dtds.maximumNumberOfParameters == 2

def tEulerH = eulerMapping.rcurry(dtds) { s, t -> s >= 100 }
assert tEulerH.maximumNumberOfParameters == 3
