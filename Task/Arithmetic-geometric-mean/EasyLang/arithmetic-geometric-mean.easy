func agm a g .
   repeat
      a0 = a
      a = (a0 + g) / 2
      g = sqrt (a0 * g)
      until abs (a0 - a) < abs (a) * 1e-15
   .
   return a
.
numfmt 0 16
print agm 1 sqrt 0.5
