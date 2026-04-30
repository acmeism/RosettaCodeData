maxd = 10000000
#
func$ rataprox f .
   if f < 0
      neg = 1
      f = -f
   .
   n = 1
   while f <> floor f
      n = n * 2
      f = f * 2
   .
   d = f
   h1 = 1
   k0 = 1
   for i = 0 to 63
      a = 0
      if n <> 0 : a = d div n
      if i > 0 and a = 0 : break 1
      x = d
      d = n
      n = x mod n
      x = a
      if k1 * a + k0 >= maxd
         x = (maxd - k0) div k1
         if x * 2 >= a or k1 >= maxd
            i = 65
         else
            break 1
         .
      .
      h2 = x * h1 + h0
      h0 = h1
      h1 = h2
      k2 = x * k1 + k0
      k0 = k1
      k1 = k2
   .
   num = h1
   denom = k1
   if neg = 1 : num = -num
   return num & "/" & denom
.
print rataprox 0.9054054054
print rataprox 0.5185185185
print rataprox 0.75
print rataprox 0.33333333333
print rataprox 0.88888888888
