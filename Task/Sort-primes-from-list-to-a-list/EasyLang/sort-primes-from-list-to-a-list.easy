fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
proc insert v &d[] .
   i = len d[]
   d[] &= 0
   while i > 0 and d[i] > v
      d[i + 1] = d[i]
      i -= 1
   .
   d[i + 1] = v
.
inp[] = [ 2 43 81 122 63 13 7 95 103 ]
for v in inp[]
   if isprim v = 1 : insert v d[]
.
print d[]
