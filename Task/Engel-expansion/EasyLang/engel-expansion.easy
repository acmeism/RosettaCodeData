func ceil x .
   f = floor x
   if f = x : return f
   return f + 1
.
func[] engelenc x .
   while x > 0
      ai = ceil (1 / x)
      x = x * ai - 1
      a[] &= ai
   .
   return a[]
.
func engeldec a[] .
   p = 1
   for ai in a[]
      p *= ai
      x = x + 1 / p
   .
   return x
.
numfmt 0 11
a[] = engelenc 3.14159265358979
print a[]
print engeldec a[]
