func biased n .
   return if randomf < 1 / n
.
func unbiased n .
   repeat
      a = biased n
      b = biased n
      until a <> b
   .
   return a
.
m = 50000
for n = 3 to 6
   c1 = 0
   c2 = 0
   for i to m
      c1 += biased n
      c2 += unbiased n
   .
   print n & ": " & 100 * c1 / m & " " & 100 * c2 / m
.
