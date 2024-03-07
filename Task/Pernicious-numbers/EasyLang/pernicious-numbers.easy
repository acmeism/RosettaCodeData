fastfunc isprim num .
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
func popc n .
   while n > 0
      r += n mod 2
      n = n div 2
   .
   return r
.
n = 1
while cnt < 25
   if isprim popc n = 1
      write n & " "
      cnt += 1
   .
   n += 1
.
print ""
n = 1
for n = 888888877 to 888888888
   if isprim popc n = 1
      write n & " "
   .
.
