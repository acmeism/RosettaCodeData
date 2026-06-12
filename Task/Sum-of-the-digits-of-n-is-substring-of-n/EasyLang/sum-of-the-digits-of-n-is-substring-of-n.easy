fastfunc digsum h .
   while h > 0
      sum += h mod 10
      h = h div 10
   .
   return sum
.
for i = 0 to 999
   h = digsum i
   if strpos i h <> 0
      write i & " "
   .
.
