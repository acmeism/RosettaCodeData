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
      e = e * 16 + s mod 16
      s = s div 16
   .
   return e
.
digs$[] = strchars "0123456789abcdef"
func$ hex n .
   if n = 0 : return ""
   return hex (n div 16) & digs$[n mod 16 + 1]
.
for i = 2 to 499
   if isprim i = 1 and reverse i = i
      write hex i & " "
   .
.
print ""
