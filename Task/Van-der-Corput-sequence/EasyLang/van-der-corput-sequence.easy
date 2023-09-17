func vdc b n .
   s = 1
   while n > 0
      s *= b
      m = n mod b
      v += m / s
      n = n div b
   .
   return v
.
for b = 2 to 5
   write "base " & b & ":"
   for n range0 10
      write " " & vdc b n
   .
   print ""
.
