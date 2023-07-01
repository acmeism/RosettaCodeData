def tNewton = { s, s0, t0, tR, k ->
    tR + (t0 - tR) * Math.exp(k * (s0 - s))
}
assert tNewton.maximumNumberOfParameters == 5

def tAnalytic = tNewton.rcurry(0, 100, 20, 0.07)
assert tAnalytic.maximumNumberOfParameters == 1
