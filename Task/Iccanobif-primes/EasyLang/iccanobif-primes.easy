fastfunc isprim num .
   if num < 2 : return 0
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
func reverse s .
   while s > 0
      e = e * 10 + s mod 10
      s = s div 10
   .
   return e
.
curr = 1
while cnt < 10
   next = prev + curr
   prev = curr
   curr = next
   if isprim reverse curr = 1
      cnt += 1
      write reverse curr & " "
   .
.
print ""
