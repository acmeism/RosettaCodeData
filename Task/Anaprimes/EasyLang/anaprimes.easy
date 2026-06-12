fastfunc isprim num .
   if num mod 2 = 0 and num > 2 : return 0
   i = 3
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 2
   .
   return 1
.
fastfunc nextprim prim .
   repeat
      prim += 1
      until isprim prim = 1
   .
   return prim
.
func group n .
   while n > 0
      d = n mod 10
      n = n div 10
      h = pow 10 d
      r += h
   .
   return r
.
hashsz = 199999
len hashind[] hashsz
len hashval[] hashsz
global maxcnt grcnt[] grmax[] grmin[] .
#
func hash ind .
   hi = ind mod hashsz + 1
   while hashind[hi] <> 0 and hashind[hi] <> ind
      hi = hi mod hashsz + 1
   .
   return hi
.
prim = 1
for limit in [ 1000 10000 100000 1000000 ]
   repeat
      prim = nextprim prim
      until prim >= limit
      g = group prim
      hi = hash g
      if hashind[hi] = 0
         hashind[hi] = g
         grcnt[] &= 1
         grmax[] &= prim
         grmin[] &= prim
         hashval[hi] = len grcnt[]
      else
         i = hashval[hi]
         grcnt[i] += 1
         grmax[i] = higher grmax[i] prim
         grmin[i] = lower grmin[i] prim
         maxcnt = higher grcnt[i] maxcnt
      .
   .
   print maxcnt
   for i to len grcnt[]
      if grcnt[i] = maxcnt
         print grmin[i] & " " & grmax[i]
      .
   .
   print ""
.
