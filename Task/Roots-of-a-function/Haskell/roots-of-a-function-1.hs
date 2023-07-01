f x = x^3-3*x^2+2*x

findRoots start stop step eps =
  [x | x <- [start, start+step .. stop], abs (f x) < eps]
