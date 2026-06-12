fastfunc isprim num .
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
for i = 2 to 999
   if isprim i = 1 and reverse i = i : write i & " "
.
print ""
