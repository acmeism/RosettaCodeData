fastfunc isprim num .
   if num mod 2 = 0 and num <> 2 : return 0
   i = 3
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 2
   .
   return 1
.
func log x .
   return log10 x / log10 2.7182818284590452354
.
euler = 0.5772156649
for x = 2 to 1e6
   if isprim x = 1
      m += log (1 - (1 / x)) + (1 / x)
   .
.
numfmt 0 11
print "mm = " & euler + m
