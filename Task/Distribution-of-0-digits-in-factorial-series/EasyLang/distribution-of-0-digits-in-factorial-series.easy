proc bnmul &a[] b .
   for i to len a[]
      h = c + a[i] * b
      a[i] = h mod 10000000
      c = h div 10000000
   .
   if c > 0 : a[] &= c
.
func nzeros &bn[] .
   for d in bn[]
      for i to 7
         cnt += if d mod 10 = 0
         d = d div 10
      .
   .
   cnt -= 7 - (floor log10 bn[$] + 1)
   return cnt
.
func bnlen &bn[] .
   if bn[] = [ 0 ] : return 1
   return (len bn[] - 1) * 7 + floor log10 bn[$] + 1
.
f[] = [ 1 ]
numfmt 0 9
lim = 100
for n to 10000
   bnmul f[] n
   sum += nzeros f[] / bnlen f[]
   if n = lim
      print sum / n
      lim *= 10
   .
.
