fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 1
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
func[] big n .
   while n > 0
      r[] &= n mod 10000000
      n = n div 10000000
   .
   return r[]
.
func[] bnmul a[] b[] .
   # this multiplication is limited to 300 digits accuracy
   len r[] len a[] + len b[]
   max = higher 1 (len a[] - 45)
   for ia = max to len a[]
      h = 0
      for ib = 1 to len b[]
         h += r[ia + ib - 1] + b[ib] * a[ia]
         r[ia + ib - 1] = h mod 10000000
         h = h div 10000000
      .
      r[ia + ib - 1] += h
   .
   while r[$] = 0
      len r[] -1
   .
   return r[]
.
func$ str bn[] .
   for i = len bn[] downto 1
      s$ &= bn[i]
   .
   return s$
.
func bndlen b[] .
   return (len b[] - 1) * 7 + floor log10 b[$] + 1
.
primor[] = [ 1 ]
prim = 2
i = 0
while i < 10
   print str primor[]
   primor[] = bnmul primor[] big prim
   prim = nextprim prim
   i += 1
.
print ""
print bndlen primor[]
for lim in [ 100 1000 10000 100000 ]
   while i < lim
      primor[] = bnmul primor[] big prim
      prim = nextprim prim
      i += 1
   .
   print bndlen primor[]
.
