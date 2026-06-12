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
func gcd a b .
   while b <> 0
      h = b
      b = a mod b
      a = h
   .
   return a
.
func wolstenholme n .
   f = 1
   for i = 2 to n
      f *= i * i
   .
   for i = 1 to n
      v += f / (i * i)
   .
   return v / gcd v f
.
for i to 11
   w = wolstenholme i
   w[] &= w
   print w
.
print ""
for w in w[]
   if isprim w = 1
      print w
   .
.
