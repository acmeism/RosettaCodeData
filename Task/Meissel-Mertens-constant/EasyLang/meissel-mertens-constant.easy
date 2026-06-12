fastfunc isprim num .
   if num mod 2 = 0 and num <> 2 : return 0
   i = 3
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 2
   .
   return 1
.
func logn x .
   return log x 0
.
euler = 0.5772156649
for x = 2 to 1e6
   if isprim x = 1
      m += logn (1 - (1 / x)) + (1 / x)
   .
.
numfmt 0 11
print "mm = " & euler + m
