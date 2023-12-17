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
func nextprim num .
   while isprim num = 0
      num += 1
   .
   return num
.
len digs[] 10
prim = 1
while len prsw[] < 3 or len prdsw[] < 3
   prim = nextprim (prim + 1)
   h = prim
   h[] = [ ]
   while h > 0
      d = h mod 10
      digs[d + 1] += 1
      h[] &= d
      h = h div 10
   .
   for i = len h[] downto 1
      sw = sw * 10 + h[i]
   .
   if isprim sw = 1
      prsw[] &= sw
   .
   dsw = 0
   for i to 10
      if digs[i] = 0
         h = 10
      else
         h = 1 + floor log10 digs[i]
         h = pow 10 h
      .
      dsw = dsw * h + digs[i]
   .
   if isprim dsw = 1
      prdsw[] &= dsw
   .
.
print prsw[]
print prdsw[]
