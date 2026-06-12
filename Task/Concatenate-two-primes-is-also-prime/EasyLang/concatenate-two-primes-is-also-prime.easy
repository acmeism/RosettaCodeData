proc sort &d[] .
   for i = 1 to len d[] - 1
      for j = i + 1 to len d[]
         if d[j] < d[i] : swap d[j] d[i]
      .
   .
.
func isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
for i = 2 to 99
   if isprim i = 1 : prims[] &= i
.
for p1 in prims[] : for p2 in prims[]
   h = number ("" & p1 & p2)
   if isprim h = 1 : r[] &= h
.
sort r[]
print r[]
