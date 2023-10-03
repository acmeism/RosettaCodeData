func isprim num .
   if num < 2
      return 0
   .
   i = 2
   while i <= sqrt num
      if num mod i = 0
         return 0
      .
      i += 1
   .
   return 1
.
func count n .
   f = 2
   repeat
      if n mod f = 0
         cnt += 1
         n /= f
      else
         f += 1
      .
      until n = 1
   .
   return cnt
.
for i = 2 to 120
   n = count i
   if isprim n = 1
      write i & " "
   .
.
