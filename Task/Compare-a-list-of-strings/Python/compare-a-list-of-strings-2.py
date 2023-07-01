from operator import (eq, lt)


xs = ["alpha", "beta", "gamma", "delta", "epsilon", "zeta",
      "eta", "theta", "iota", "kappa", "lambda", "mu"]

ys = ["alpha", "beta", "gamma", "delta", "epsilon", "zeta",
      "eta", "theta", "iota", "kappa", "lambda", "mu"]

az = sorted(xs)

print (
    all(map(eq, xs, ys)),

    all(map(lt, xs, xs[1:])),

    all(map(lt, az, az[1:]))
)
