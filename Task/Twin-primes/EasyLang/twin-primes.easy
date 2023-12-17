fastfunc isprim num .
   if num mod 2 = 0 and num > 2
      return 0
   .
   i = 3
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 2
   .
   return 1
.
func count limit .
   p2 = 1
   p3 = 1
   for i = 5 to limit
      p3 = p2
      p2 = p1
      p1 = isprim i
      if p3 = 1 and p1 = 1
         cnt += 1
      .
   .
   return cnt
.
n = 1
for i = 1 to 6
   n *= 10
   print "twin prime pairs < " & n & " : " & count n
.
